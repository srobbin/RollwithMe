module DirectionsHelper
  def step_directions(step)
    content_tag :div, class: 'details' do
      step['detail'].each_with_index do |detail, index|
        if index == step['detail'].size - 1
          instruction = detail['html_instructions'].html_safe
          concat content_tag(:p, instruction)
        else
          instruction = detail['html_instructions'].html_safe
          concat content_tag(:p, instruction) + tag(:hr, class: 'subtle-hr')
        end
      end
    end
  end
end
