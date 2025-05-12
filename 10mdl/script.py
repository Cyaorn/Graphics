import mdl
from display import *
from matrix import *
from draw import *

def run(filename):
    """
    This function runs an mdl script
    """
    p = mdl.parseFile(filename)

    if p:
        (commands, symbols) = p
    else:
        print("Parsing failed.")
        return

    view = [0,
            0,
            1];
    ambient = [50,
               50,
               50]
    light = [[0.5,
              0.75,
              1],
             [255,
              255,
              255]]

    color = [0, 0, 0]
    tmp = new_matrix()
    ident( tmp )

    stack = [ [x[:] for x in tmp] ]
    screen = new_screen()
    zbuffer = new_zbuffer()
    tmp = []
    step_3d = 100
    consts = ''
    symbols['.white'] = ['constants',
                         {'red': [0.2, 0.5, 0.5],
                          'green': [0.2, 0.5, 0.5],
                          'blue': [0.2, 0.5, 0.5]}]
    reflect = '.white'
    
    polygons = []
    edges = []

    print(symbols)
    for command in commands:
        print(command)
        keyword = command['op']
        if keyword == 'push':
            stack.append([x[:] for x in stack[-1]])
        elif keyword == 'pop':
            stack.pop()
        elif keyword == 'move':
            mat = make_translate(*command['args'])
            matrix_mult(stack[-1], mat)
            stack[-1] = [x[:] for x in mat]
        elif keyword == 'scale':
            mat = make_scale(*command['args'])
            matrix_mult(stack[-1], mat)
            stack[-1] = [x[:] for x in mat]
        elif keyword == 'rotate':
            axis, degrees = command['args']
            degrees = degrees * math.pi / 180
            if axis == 'x':
                mat = make_rotX(float(degrees))
            elif axis == 'y':
                mat = make_rotY(float(degrees))
            elif axis == 'z':
                mat = make_rotZ(float(degrees))
            else:
                print 'bad axis oof'
                continue
            matrix_mult(stack[-1], mat)
            stack[-1] = [x[:] for x in mat]
        elif keyword == 'sphere':
            add_sphere(*([polygons] + [float(x) for x in command['args']] + [step_3d]))
            matrix_mult(stack[-1], polygons)
            if command['constants']:
                draw_polygons(polygons, screen, zbuffer, view, ambient, light, symbols, command['constants'])
            else:
                draw_polygons(polygons, screen, zbuffer, view, ambient, light, symbols, reflect)
            polygons = []
        elif keyword == 'torus':
            add_torus(*([polygons] + [float(x) for x in command['args']] + [step_3d]))
            matrix_mult(stack[-1], polygons)
            if command['constants']:
                draw_polygons(polygons, screen, zbuffer, view, ambient, light, symbols, command['constants'])
            else:
                draw_polygons(polygons, screen, zbuffer, view, ambient, light, symbols, reflect)
            polygons = []
        elif keyword == 'box':
            add_box(*([polygons] + [float(x) for x in command['args']]))
            matrix_mult(stack[-1], polygons)
            if command['constants']:
                draw_polygons(polygons, screen, zbuffer, view, ambient, light, symbols, command['constants'])
            else:
                draw_polygons(polygons, screen, zbuffer, view, ambient, light, symbols, reflect)
            polygons = []
        elif keyword == 'line':
            add_edge(*([edges] + [float(x) for x in command['args']]))
            matrix_mult(stack[-1], edges)
            draw_line(edges, screen, zbuffer, color)
            edges = []
        elif keyword == 'save':
            save_extension(screen, command['args'][0] + '.png')
        elif keyword == 'display':
            display(screen)
        else:
            print 'bad word oof oof'
            
            
        
