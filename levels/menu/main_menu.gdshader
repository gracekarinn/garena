shader_type canvas_item;

uniform float SPEED = 2;

void vertex() {
    // Move the texture to the right at a constant speed
    UV.x += TIME * SPEED;
}
