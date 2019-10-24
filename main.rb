require '/Users/pawel/machine-learning/hand-write/hand_written_image.rb'
require 'ruby-fann'
require 'pry'

class HandWrite
  def initialize_fann
    train = RubyFann::TrainData.new(
      inputs: training_inputs,
      desired_outputs: training_desired_outputs
    )

    fann = RubyFann::Standard.new(
      num_inputs: 784,
      hidden_neurons: [98, 24],
      num_outputs: 10
    )

    # 1000 max_epochs, 10 errors between reports and 0.1 desired MSE (mean-squared-error)
    fann.train_on_data(train, 100, 10, 0.06)
    fann
  end

  def training_inputs
    @training_inputs ||= training_set.values.reduce { |ar, el| ar + el }
  end

  def training_desired_outputs
    @training_desired_outputs ||= training_set.flat_map do |key, values|
      output = Array.new(10) { |i| i == key ? 1 : 0 }
      [output] * values.size
    end
  end

  def training_set
    @training_set ||= Array.new(10) do |number|
      path = "training_set/#{number}/"

      [
        number,
        Dir.entries(path)
           .select { |entry| entry.end_with?('.jpg') }
           .first(2000)
           .map { |file| "training_set/#{number}/#{file}" }
           .map { |filepath| HandWrittenImage.new(filepath).to_a }
      ]
    end.to_h
  end
end

hw = HandWrite.new
fann = hw.initialize_fann

test_files = [
  '/Users/pawel/machine-learning/hand-write/training_set/0/img_129.jpg',
  '/Users/pawel/machine-learning/hand-write/training_set/1/img_60.jpg',
  '/Users/pawel/machine-learning/hand-write/training_set/2/img_55.jpg',
  '/Users/pawel/machine-learning/hand-write/training_set/3/img_7133.jpg',
  '/Users/pawel/machine-learning/hand-write/training_set/4/img_42.jpg'
].map do |path|
  HandWrittenImage.new(path)
end

test_files.each do |test_file|
  puts test_file.to_s + "\n\n"
  pp fann.run(test_file.to_a)
end
