#This file is used to shuffle a list of 10000 words.
def shuffle_list(list)
  list.shuffle!
  File.open("shuffled.txt", "w") do |f|
    list.each_with_index do |word, idx|
      if idx == 10000
        break
      end
      f.write(word + "\n")
    end
  end
end

def read
  array = []
  File.open("words2.txt", "r") do |f|
    f.each_line do |line|
      array << line.chomp
    end
  end
  array
end

shuffle_list(read)
