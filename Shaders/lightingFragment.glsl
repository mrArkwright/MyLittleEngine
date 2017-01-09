//
//  lightingFragment.glsl
//  My Little Engine
//
//  Created by Jannik Theiß on 26.12.2016.
//
//

#version 150

uniform vec3 lightPosition;
uniform vec3 vertexColor;


//in vec3 viewPosition;
in vec3 Normal;
in vec3 FragmentPosition;

out vec4 color;

void main(void) {
	
	float ambientStrength = 0.5;
	vec3 lightColor = vec3(1.0, 1.0, 1.0);
	vec3 ambient = ambientStrength * lightColor;
	
	vec3 norm = normalize(Normal);
	vec3 lightDir = normalize(lightPosition - FragmentPosition);
	float diff = max(dot(norm, lightDir), 0.0);
	vec3 diffuse = diff * lightColor;
	
//	float specularStrength = 0.5;
//	vec3 viewDir = normalize(viewPosition - FragmentPosition);
//	vec3 reflectDir = reflect(-lightDir, norm);
//	float spec = pow(max(dot(viewDir, reflectDir), 0.0), 32);
//	vec3 specular = specularStrength * spec * lightColor;
	
	vec3 result = (ambient + diffuse) * vertexColor;
	color = vec4(result, 1.0);
}
