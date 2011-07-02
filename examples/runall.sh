alf --text autonum           suppliers
alf --text autonum           suppliers -- unique_id
alf --text defaults          suppliers -- country "'Belgium'"
alf --text defaults --strict suppliers -- country "'Belgium'"
alf --text compact           suppliers
alf --text sort              suppliers -- name asc
alf --text sort              suppliers -- city desc name asc
alf --text clip              suppliers -- name city
alf --text clip              suppliers --allbut -- name city
alf --text project           suppliers -- name city
alf --text project --allbut  suppliers -- name city
alf --text extend            supplies  -- sp 'sid + "/" + pid' big "qty > 100 ? true : false"
alf --text rename            suppliers -- name supplier_name city supplier_city
alf --text restrict          suppliers -- "status > 20"
alf --text restrict          suppliers -- city "'London'"
alf --text nest              suppliers -- city status loc_and_status
alf --text unwrap            suppliers -- loc_and_status
alf --text group             supplies  -- pid qty supplying
alf --text group --allbut    supplies  -- sid supplying
alf --text ungroup           group     -- supplying
alf --text summarize         supplies  -- --by=sid total_qty "sum(:qty)"
alf --text quota             supplies  -- --by=sid --order=qty position count sum_qty "sum(:qty)"
alf --text join              suppliers supplies
alf --text union             suppliers suppliers
alf --text intersect         suppliers suppliers
alf --text minus             suppliers suppliers
