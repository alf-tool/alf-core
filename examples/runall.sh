alf --render=text --input=suppliers defaults x 1 y "'hello'"
alf --render=text --input=suppliers project name city
alf --render=text --input=suppliers project --allbut name city
alf --render=text --input=supplies extend sp 'sid + "/" + pid' big "qty > 100 ? true : false"
alf --render=text --input=suppliers rename name supplier_name city supplier_city
alf --render=text --input=suppliers restrict "status > 20"
alf --render=text --input=suppliers restrict city "'London'"
alf --render=text --input=suppliers nest city status loc_and_status
alf --render=text --input=nest unnest loc_and_status
alf --render=text --input=supplies group pid qty supplying
alf --input=supplies group --allbut sid supplying
alf --render=text --input=group ungroup supplying
alf --render=text --input=supplies summarize --by=sid total_qty "sum(:qty)"
alf --render=text --input=supplies quota --by=sid --order=qty position count sum_qty "sum(:qty)"
alf --render=text --input=suppliers,supplies join
alf --render=text --input=suppliers,suppliers union
