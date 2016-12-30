class PreProcessor
  def self.fix_dom!(dom)
    fix_lists!(dom)
    fix_boxes!(dom)
  end

  def self.fix_lists!(dom)
    ['BulletedList', 'NumList', 'UnmarkedList'].each do |type|
      ['1', '2'].each do |num|
        dom.css("p[type='#{type}#{num}_First']").each do |list_start|
          node = list_start
          while node.next_sibling && node.next_sibling.attr('type') && node.next_sibling.attr('type').start_with?(type) && !node.next_sibling.attr('type').ends_with?('First')
            sibling = node.next_sibling
            node = node.next_sibling
            sibling.parent = list_start
          end
        end
      end
    end
  end

  def self.fix_boxes!(dom)
    ['box', 'sidebar', 'feature'].each do |tag_type|
      dom.css('p').each do |box_element|
        if box_element.attr('type').downcase.start_with?(tag_type)
          node = box_element.next_sibling
          box = box_element.add_next_sibling("<box class=\"#{tag_type}\"></box>").first
          box_element.parent = box
          while node && node.name == 'p' && node.attr('type') && node.attr('type').downcase.start_with?(tag_type)
            sibling = node.next_sibling
            node.parent = box
            node = sibling
          end
        end
      end
    end
  end
end
