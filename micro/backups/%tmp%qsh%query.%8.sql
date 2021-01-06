
select distinct rptgrp,
                count(*)
from fintr f
inner join some_tab t on f.a = t.v
group by rptgrp;


