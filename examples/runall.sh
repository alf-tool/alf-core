alf --render=text defaults          suppliers -- country "'Belgium'"
alf --render=text defaults --strict suppliers -- country "'Belgium'"
alf --render=text compact           suppliers
alf --render=text sort              suppliers -- name asc
alf --render=text sort              suppliers -- city desc name asc
alf --render=text clip              suppliers -- name city
alf --render=text clip              suppliers --allbut -- name city
alf --render=text project           suppliers -- name city
alf --render=text project --allbut  suppliers -- name city
alf --render=text extend            supplies  -- sp 'sid + "/" + pid' big "qty > 100 ? true : false"
alf --render=text rename            suppliers -- name supplier_name city supplier_city
alf --render=text restrict          suppliers -- "status > 20"
alf --render=text restrict          suppliers -- city "'London'"
alf --render=text nest              suppliers -- city status loc_and_status
alf --render=text unnest            suppliers -- loc_and_status
alf --render=text group             supplies  -- pid qty supplying
alf --render=text group --allbut    supplies  -- sid supplying
alf --render=text ungroup           group     -- supplying
alf --render=text summarize         supplies  -- --by=sid total_qty "sum(:qty)"
alf --render=text quota             supplies  -- --by=sid --order=qty position count sum_qty "sum(:qty)"
alf --render=text join              suppliers supplies
alf --render=text union             suppliers suppliers
alf --render=text intersect         suppliers suppliers
alf --render=text minus             suppliers suppliers
