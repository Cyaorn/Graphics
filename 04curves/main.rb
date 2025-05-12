require_relative 'line'
require_relative 'matrix'
require_relative 'transform'
require_relative 'curve'

def main(default=601)
    out = Array.new(default) {Array.new(default, [0, 0, 0])}
    transform = ident(4)
    edges = Array.new(0)
    file_data = []
    script()
    File.open('script.txt', 'r') {|file|
        file.each_line { |line|
            file_data.append(line.strip)
        }
    }
    while file_data.length > 0 
        current = file_data.shift # pop first element off array
        if current[0] == '#'
            next # continue in python
        elsif current == 'line'
            coords = file_data.shift.split(" ")
            add_edge(edges, *(coords.map {|x| x.to_f}))
        elsif current == 'ident'
            transform = ident(4)
        elsif current == 'scale'
            factors = file_data.shift.split(" ")
            mult(scale(*factors), transform)
        elsif current == 'move'
            dists = file_data.shift.split(" ")
            mult(trans(*dists), transform)
        elsif current == 'rotate'
            args = file_data.shift.split(" ")
            mult(rot(*args), transform)
        elsif current == 'apply'
            mult(transform, edges)
        elsif current == 'display'
            out = Array.new(default) {Array.new(default, [0, 0, 0])}
            draw_matrix(out, edges)
            save_ppm(out, default)
            `display image.ppm` # ` ` runs terminal commands
        elsif current == 'save'
            out_file = file_data.shift
            out = Array.new(default) {Array.new(default, [0, 0, 0])}
            draw_matrix(out, edges)
            save_ppm(out, default)
            `convert image.ppm #{out_file}`
        elsif current == 'circle'
            args = file_data.shift.split(" ")
            args.map! {|x| x.to_f} # ! actually replaces the array
            add_circle(edges, *args)
        elsif current == 'hermite'
            args = file_data.shift.split(" ")
            args.map! {|x| x.to_f}
            add_hermite(edges, *args)
        elsif current == 'bezier'
            args = file_data.shift.split(" ")
            args.map! {|x| x.to_f}
            add_bezier(edges, *args)
        end
    end
end

def save_ppm(ary, dim)
    File.open('image.ppm', 'w') {|file|
        file.write("P3\n#{dim}\n#{dim}\n255\n")
        ary.length.times {|i|
            ary[i].length.times{|j|
                3.times {|k|
                    # puts "#{i} #{j} #{k}"
                    file.write(ary[i][j][k].to_s + ' ')
                }
            }
        }
    }
end

def script()
    stuff = [100, 200, 300, 400, 500]
    File.open('script.txt', 'w') {|file|
        stuff.length.times {|x|
            x.times {|y|
                file.write("bezier\n")
                file.write("#{stuff[y]} 0 #{stuff[x]} #{stuff[x]} 0 #{stuff[y]} 0 0\n")
                file.write("hermite\n")
                file.write("0 #{stuff[y]} #{stuff[x]} #{stuff[x]} 100 100 -100 100\n")
            }
        }
        file.write("display\n")
        file.write("save\nimage.png")
    }
end

main(600)
