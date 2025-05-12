import math
from display import *


  # IMPORANT NOTE

  # Ambient light is represeneted by a color value

  # Point light sources are 2D arrays of doubles.
  #      - The first index (LOCATION) represents the vector to the light.
  #      - The second index (COLOR) represents the color.

  # Reflection constants (ka, kd, ks) are represened as arrays of
  # doubles (red, green, blue)

AMBIENT = 0
DIFFUSE = 1
SPECULAR = 2
LOCATION = 0
COLOR = 1
SPECULAR_EXP = 4

#lighting functions
def get_lighting(normal, view, ambient, light, areflect, dreflect, sreflect ):
    normalize(normal)
    normalize(view)
    normalize(light[LOCATION])
    a = calculate_ambient(ambient, areflect)
    d = calculate_diffuse(light, dreflect, normal)
    s = calculate_specular(light, sreflect, view, normal)
    return limit_color(list(int(sum(x)) for x in zip(a, d, s)))

def calculate_ambient(alight, areflect):
    color = [0, 0, 0]
    for i in range(3):
        color[i] = alight[i] * areflect[i]
    return limit_color(color)

def calculate_diffuse(light, dreflect, normal):
    color = [0, 0, 0]
    # for _light in light:  in case of multiple light sources
    #    _color = [0, 0, 0]
    for i in range(3):
        color[i] += light[COLOR][i] * dreflect[i]
        color[i] = color[i] * dot_product(normal, light[LOCATION])
    return limit_color(color)

def calculate_specular(light, sreflect, view, normal):
    color = [0, 0, 0]
    p = (2 * x * dot_product(light[LOCATION], normal) for x in normal)
    r = list(_p - _l for _p, _l in zip(p, light[LOCATION]))
    vectors = dot_product(r, view)
    if vectors < 0:
        return [0, 0, 0]
    final = math.pow(dot_product(r, view), SPECULAR_EXP)
    for i in range(3):
        color[i] += light[COLOR][i] * sreflect[i] * final  
    return limit_color(color)

def limit_color(color):
    for i in range(3):
        if color[i] > 255:
            color[i] = 255
        if color[i] < 0:
            color[i] = 0
    return color 
    

#vector functions
#normalize vetor, should modify the parameter
def normalize(vector):
    magnitude = math.sqrt( vector[0] * vector[0] +
                           vector[1] * vector[1] +
                           vector[2] * vector[2])
    for i in range(3):
        vector[i] = vector[i] / magnitude

#Return the dot product of a . b
def dot_product(a, b):
    return a[0] * b[0] + a[1] * b[1] + a[2] * b[2]

#Calculate the surface normal for the triangle whose first
#point is located at index i in polygons
def calculate_normal(polygons, i):

    A = [0, 0, 0]
    B = [0, 0, 0]
    N = [0, 0, 0]

    A[0] = polygons[i+1][0] - polygons[i][0]
    A[1] = polygons[i+1][1] - polygons[i][1]
    A[2] = polygons[i+1][2] - polygons[i][2]

    B[0] = polygons[i+2][0] - polygons[i][0]
    B[1] = polygons[i+2][1] - polygons[i][1]
    B[2] = polygons[i+2][2] - polygons[i][2]

    N[0] = A[1] * B[2] - A[2] * B[1]
    N[1] = A[2] * B[0] - A[0] * B[2]
    N[2] = A[0] * B[1] - A[1] * B[0]

    return N

# print(calculate_ambient([500, 500, 500], [1, 1, 1]))