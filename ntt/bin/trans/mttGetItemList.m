function [items,item_values] = mttGetItemList(text)
    if isempty(text)
	    items = [] ;
        item_values = [] ;
    else
        counter = 0 ;
        fetching_items = 1 ;
        while fetching_items
            counter = counter + 1 ;
            [next_item,text] = mttCutText(text,',') ;
            
            [item_name,item_value] = mttCutText(next_item,'=') ;
            
            items{counter} = item_name ;
            item_values{counter} = item_value ;
            
            if isempty(text)
                fetching_items = 0 ;
            end
        end
    end
