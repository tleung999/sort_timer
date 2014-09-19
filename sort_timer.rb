#run the app using the following command line
#sample run "ruby sort_timer.rb <sort_type> <input_file_name> <output_file_name>"
#pseudo code
#1. Take in the command and use argv to parse the sort type and file file_name
#2. Read in the file and push each line into an array
#3. Using a switch determine the sort type to use.
#4. Before running the sort run Time to get the start Time
#5. Execute sort function
#6. Stop timer when complete
#7. Write sorted array into output file.  First line of output file should display the time it took to complete
#8. Return the time difference and confirmation message that sort is done.

class SortTimer
  class << self
    def initialize(sort_type, input_file, output_file)
      @sort_type = sort_type
      @input_file = input_file
      @output_file = output_file
      @unsorted_array = []
      @sorted_array = []
      @start_time = nil
      @end_time = nil
      @time_difference = nil
      run_sort
      create_output_file
    end

  private
    def run_sort
      read_file
      @start_time = Time.now
      case @sort_type
      when "bubble"
        bubble_sort
      when "merge"
        mergesort(@unsorted_array)
      when "quick"
        @sorted_array = QuickSort.sort!(@unsorted_array)
        create_output_file
      when "shell"
        @sorted_array = ShellSort.sort(@unsorted_array)
        create_output_file
      else
        puts "Available sort options are bubble, merge, quick, shell"
        exit
      end
      @end_time = Time.now
      @time_difference = @end_time - @start_time
      puts "#{@sort_type.capitalize} Sort Complete: Total Time: #{@time_difference}"
    end


    def read_file
      File.open(@input_file, "r") do |f|
        f.each_line do |line|
          @unsorted_array << line.chomp
        end
      end
    end

    def create_output_file
      File.open(@output_file, "w") do |f|
        @sorted_array.each do |element|
          f.write(element + "\n")
        end
      end
    end


    def bubble_sort
      begin
        swapped = false
        @unsorted_array.each_index do |index|
          if !@unsorted_array[index+1].nil?
            if @unsorted_array[index] > @unsorted_array[index+1]
              temp = @unsorted_array[index]
              @unsorted_array[index] = @unsorted_array[index+1]
              @unsorted_array[index+1] = temp
              swapped = true
            end
          end
        end
      end while swapped
      @sorted_array = @unsorted_array
    end

    def mergesort(list)
      return list if list.size <= 1
      mid = list.size / 2
      left  = list[0, mid]
      right = list[mid, list.size-mid]
      merge(mergesort(left), mergesort(right))
    end

    def merge(left, right)
      sorted = []
      until left.empty? or right.empty?
        if left.first <= right.first
          sorted << left.shift
        else
          sorted << right.shift
        end
      end
      @sorted_array = sorted.concat(left).concat(right)
    end

  end
end

class ShellSort
  def self.sort(keys)
    sort!(keys.clone)
  end

  def self.sort!(keys)
    gap = keys.size/2
    while gap > 0
      for j in gap...keys.size
        key = keys[j]
        i = j
        while (i >= gap and keys[i-gap] > key)
          keys[i] = keys[i-gap]
          i -= gap
        end
        keys[i] = key
      end
      gap /= 2
    end
    keys
  end
end

class QuickSort

  def self.sort!(keys)
    quick(keys,0,keys.size-1)
  end

  private

  def self.quick(keys, left, right)
    if left < right
      pivot = partition(keys, left, right)
      quick(keys, left, pivot-1)
      quick(keys, pivot+1, right)
    end
    keys
  end

  def self.partition(keys, left, right)
    x = keys[right]
    i = left-1
    for j in left..right-1
      if keys[j] <= x
        i += 1
        keys[i], keys[j] = keys[j], keys[i]
      end
    end
    keys[i+1], keys[right] = keys[right], keys[i+1]
    i+1
  end

end

SortTimer.initialize(ARGV[0], ARGV[1], ARGV[2])



