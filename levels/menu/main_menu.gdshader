shader_type canvas_item;

uniform float SPEED = 0.01;

void vertex() {
    UV.x += TIME * SPEED;
}
