//
//  simpleFragment.glsl
//  My Little Engine
//
//  Created by Jannik Theiß on 28.12.2016.
//
//

#version 150

uniform vec3 vertexColor;

out vec4 color;

void main(void) {
	color = vec4(vertexColor, 1.0);
}
