import threading

class ReverseIterator:
    def __init__(self, data, start):
        self.data = data
        self.position = start

    def __iter__(self):
        return self

    def __next__(self):
        if self.position >= len(self.data):
            raise StopIteration
        else:
            index = len(self.data) - self.position - 1
            result = self.data[index]
            self.position += 1

            return result

class Cycler:
    def __init__(self, max_list_size):
        # Item list
        self.item_list = []
        self.max_list_size = max_list_size
        self.item_list_lock = threading.RLock()

        # Details to relating to a switch operation
        self.switching = False
        self.previously_forward = False
        self.switching_item = 0
        self.switching_item_index = -1

    def _reverse_index(self, index):
        if len(self.item_list) > 0:
            return len(self.item_list) - index - 1

        return 0
        
    def _to_top_of_stack(self, item):
        if item:
            # Move the item to the front of the list
            if item in self.item_list:
                self.item_list.remove(item)
            self.item_list.insert(0, item)

            # Make sure our list is not too long
            if len(self.item_list) > self.max_list_size:
                del self.item_list[max_list_size:]

    def _create_list_iterator(self, switching, forward, start_index = -1):
        # If our list of items is empty, just return an empty iterator
        if len(self.item_list) == 0:
            return enumerate(self.item_list)

        # We need to create the right type of iterator depending on whether we are switching or not,
        # as the start index will need to be our cached one if we are, and whether we are switching
        # forwards or in reverse.
        #
        # If the start_index parameter to this function is -1 then it means no explicit value is being
        # passed in so we choose the appropriate value based on current state
        item_list = None
        if not switching:
            if forward:
                if (start_index == -1):
                    # We offset by 1 as index 0 is the current window
                    start_index = 1

                # Iterate forwards from the start index
                item_list = enumerate(self.item_list[start_index:], start=start_index)
            else:
                if (start_index == -1):
                    # We start at 0 as in reverse the list will have the normally final element
                    # at the front of the list, which is the element behind the normal index 0
                    start_index = 0

                # Iterate in reverse from the start index
                item_list = enumerate(ReverseIterator(self.item_list, start_index), start=start_index)
        else:
            # Get the cached index that we are currently on
            switching_index = self.switching_item_index
            
            if (start_index == -1):
                # Since we are switching, if we were switching forward and are now as well or we were
                # switching in reverse and are doing the same now, go into the if
                if (forward and self.previously_forward) or (not forward and not self.previously_forward):
                    # Reverse the index if we are going in reverse
                    if not forward:
                        switching_index = self._reverse_index(switching_index)
                        
                    # Move on to the next item in the list
                    start_index = switching_index + 1

                    # If we pass the end of the list, wrap around to the front
                    if start_index >= len(self.item_list):
                        start_index = 0
                else:
                    if forward:
                        # Move on to the next item in the list
                        start_index = switching_index + 1

                        # If we pass the end of the list, wrap around to the front
                        if start_index >= len(self.item_list):
                            start_index = 0
                    else:
                        #  Move to the previous item in the list
                        start_index = switching_index - 1

                        # If we pass the start of the list, wrap around to the back
                        if start_index < 0:
                            start_index = len(self.item_list) - 1

                        start_index = self._reverse_index(start_index)
                    
            if forward:
                # Iterate forwards from the start index
                item_list = enumerate(self.item_list[start_index:], start=start_index)
            else:
                # Iterate in reverse from the start index
                item_list = enumerate(ReverseIterator(self.item_list, start_index), start=start_index)

        return item_list

    def _iterate_items(self, live_items, item_list):
        item_index = -1

        # Iterate over our internal list of items
        for i, item in item_list:
            # Remove items from the list that are no longer live
            while item not in live_items and i < len(self.item_list):
                del self.item_list[i]

                if i < len(self.item_list):
                    item = self.item_list[i]

            # If we still have a valid index into the list, then that's the next
            # valid item
            if i < len(self.item_list):
                item_index = i
                break

        return item_index
    
    def _find_next_item(self, switching, live_items, forward):
        # We need to find the index of the next item to switch to
        item_index = self._iterate_items(live_items, self._create_list_iterator(switching, forward))

        if item_index == -1:
            # We couldn't find an item to switch to, however, we may have started iterating
            # in the middle of the list and, therefore, there might be other items at the
            # front of the list that we can switch to
            if len(self.item_list) > 0:
                item_index = self._iterate_items(live_items, self._create_list_iterator(switching, forward, 0))

            # We still couldn't find an item. If there are any items currently live,
            # set our internal list to that list and set the index to 0
            if item_index == -1:
                if len(live_items) > 0:
                    self.item_list = list(live_items)
                    item_index = 0

        # If we were switching in reverse, reverse the index that we found
        if item_index >= 0 and not forward:
            item_index = self._reverse_index(item_index)
        
        return item_index
    
    def _focus_item(self, index, item):
        # Ensure that the index is valid
        if index >= 0:
            # Update internal state
            self.switching_item = item
            self.switching_item_index = index

    def add(self, item):
        with self.item_list_lock:
            if not self.switching:
                self._to_top_of_stack(item)

    def switch(self, live_items, forward):
        with self.item_list_lock:
            # If we weren't switching before, we are now
            switching = self.switching
            if not self.switching:
                self.switching = True
                
            # Find the next item index that should have focus
            item_index = self._find_next_item(switching, live_items, forward)
            
            # If we have a valid index, get the related value
            item = None
            if item_index >= 0:
                item = self.item_list[item_index]
            
            # Focus on the found item
            self._focus_item(item_index, item)
            
            # Record the direction in which we are switching
            self.previously_forward = forward

            return item

    def release(self):
        with self.item_list_lock:
            # If we were switching then the currently focussed item moves to the top of the
            # stack, as we are about to stop switching
            if self.switching:
                self._to_top_of_stack(self.switching_item)

                # Switch operation has ended
                self.switching = False

