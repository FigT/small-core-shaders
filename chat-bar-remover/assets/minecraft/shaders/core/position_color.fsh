#version 150

in vec4 vertexColor;

uniform vec4 ColorModulator;
uniform vec2 ScreenSize;

out vec4 fragColor;


const vec3 GRAY = vec3(160f, 160f, 160f) / 255f; // main color for the gray chat line
const vec3 BLUE = vec3(119f, 179f, 233f) / 255f; // main color for the blue chat line (whilst you're typing)


bool isGrayBar(inout vec4 color) {
    return color.rgb == GRAY && color.a >= 0.99;
}

bool isBlueBar(inout vec4 color) {
    return color.rgb == BLUE && color.a >= 0.99;
}


void main() {
    // get UV position from screen-space position 
    vec2 position = (gl_FragCoord.xy / ScreenSize.xy);

    // vanilla
    vec4 color = vertexColor;

    if (color.a == 0.0) {
        discard;
    }

    fragColor = color * ColorModulator;
    // end vanilla


    // check the position (a very small sliver of the entire left side of the screen) and the vertex color
    if (position.x <= 0.005 && position.y <= 1.0 && isGrayBar(color)) {
        discard;
    }

    // these position checks could be merged into the top one, but I'll leave them separate for extra precision checking and clarity

    // check the position (a very small sliver of the bottom left of the screen) and the vertex color 
    if (position.x <= 0.005 && position.y <= 0.06 && isBlueBar(color)) {
        discard;
    }
}