module DirectionsHelper
  def step_directions(step)
    content_tag :div, class: 'well close-well' do
      step['detail'].each do |detail|
        instruction = detail['html_instructions'].html_safe
        concat content_tag(:p, instruction)
      end
    end
  end
end
