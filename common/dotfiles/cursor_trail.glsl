// Cursor trail shader for Ghostty
// Based on cursor_blaze.glsl from the community
// Reference: https://gist.github.com/chardskarth/95874c54e29da6b5a36ab7b50ae2d088

float ease(float x) {
    return pow(1.0 - x, 10.0);
}

float sdBox(in vec2 p, in vec2 b) {
    vec2 d = abs(p) - b;
    return length(max(d, 0.0)) + min(max(d.x, d.y), 0.0);
}

float getSdfRectangle(vec2 uv, vec4 rect) {
    vec2 center = rect.xy + rect.zw / 2.0;
    vec2 size = rect.zw / 2.0;
    return sdBox(uv - center, size);
}

float seg(vec2 p, vec2 a, vec2 b) {
    vec2 pa = p - a;
    vec2 ba = b - a;
    float h = clamp(dot(pa, ba) / dot(ba, ba), 0.0, 1.0);
    return length(pa - ba * h);
}

float getSdfParallelogram(vec2 uv, vec4 current, vec4 previous) {
    vec2 currentTopLeft = current.xy;
    vec2 currentBottomRight = current.xy + current.zw;
    vec2 previousTopLeft = previous.xy;
    vec2 previousBottomRight = previous.xy + previous.zw;

    float top = seg(uv, currentTopLeft, previousTopLeft);
    float right = seg(uv, currentBottomRight, previousBottomRight);
    float bottom = seg(uv, currentBottomRight, previousBottomRight);
    float left = seg(uv, currentTopLeft, previousTopLeft);

    return min(min(top, right), min(bottom, left));
}

vec2 normalize(vec2 uv) {
    return vec2(uv.x, iResolution.y - uv.y);
}

vec3 blend(vec3 base, vec3 color, float alpha) {
    return base * (1.0 - alpha) + color * alpha;
}

float antialising(float sdf) {
    return smoothstep(1.0, -1.0, sdf);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = normalize(fragCoord);
    vec3 color = texture(iChannel0, fragCoord / iResolution.xy).rgb;

    vec4 current = vec4(normalize(iCurrentCursor.xy), iCurrentCursor.zw);
    vec4 previous = vec4(normalize(iPreviousCursor.xy), iPreviousCursor.zw);

    float animationDuration = 0.5;
    float timeSinceCursorChange = iTime - iTimeCursorChange;
    float progress = clamp(timeSinceCursorChange / animationDuration, 0.0, 1.0);

    // Cursor trail
    if (progress < 1.0) {
        float distance = length(current.xy - previous.xy);
        if (distance > 0.1) {
            float sdfTrail = getSdfParallelogram(uv, current, previous);
            float trailAlpha = antialising(sdfTrail - 2.0) * ease(progress) * 0.2;
            vec3 trailColor = vec3(1.0, 0.725, 0.161); // Yellow-orange trail
            color = blend(color, trailColor, trailAlpha);
        }
    }

    // Current cursor glow
    float sdfCursor = getSdfRectangle(uv, current);
    float cursorBorder = 3.0 * (1.0 - progress * 0.5);
    float cursorAlpha = antialising(sdfCursor - cursorBorder) * 0.3;
    vec3 cursorColor = vec3(1.0, 0.0, 0.0); // Red glow
    color = blend(color, cursorColor, cursorAlpha);

    fragColor = vec4(color, 1.0);
}
