module DirectionsHelper
  def step_directions(step)
    content_tag :div, class: 'details' do
      step['detail'].each_with_index do |detail, index|
        instruction = detail['html_instructions'].html_safe
        concat content_tag(:p, instruction) + tag(:hr, class: 'subtle-hr')
        if index == step['detail'].size - 1
          instruction = detail['html_instructions'].html_safe
          concat content_tag(:p, instruction)
        end
      end
    end
  end
end
