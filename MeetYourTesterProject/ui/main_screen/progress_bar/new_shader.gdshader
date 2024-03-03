shader_type canvas_item;

// Declare a uniform for the viewport size
uniform vec2 viewport_size;

void fragment() {
    // Use the uniform for calculations instead of SCREEN_SIZE
    vec2 uv = FRAGCOORD.xy / viewport_size;

    // Define the boundaries of the frame with 45-degree cuts
    float cutSize = 10; // Adjust based on your frame's geometry
    
    // Calculate the minimum and maximum allowed UVs based on the cuts
    float minX = cutSize * (viewport_size.y / viewport_size.x);
    float maxX = 1.0 - minX;
    float minY = cutSize;
    float maxY = 1.0 - cutSize;

    // Determine if the fragment is within the cut areas
    bool inCutArea = (uv.x < minX && uv.y < minY) ||
                     (uv.x > maxX && uv.y < minY) ||
                     (uv.x < minX && uv.y > maxY) ||
                     (uv.x > maxX && uv.y > maxY);

    // Discard pixels in the cut areas
    if (inCutArea) {
        discard;
    }
}