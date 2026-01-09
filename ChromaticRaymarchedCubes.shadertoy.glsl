struct pointlight { vec3 pointlightTransformPosition; vec3 pointlightEmissiveColor; float pointlightEmissiveFactor; float pointlightEmissiveRange; };

struct material { vec3 materialAlbedoColor; float materialAmbientFactor; float materialDiffuseFactor; float materialSpecularFactor; float materialSpecularShininess; float materialMetallicFactor; };

struct surface { float surfaceDistance; material surfaceMaterial; };

const vec3 CameraSettingsFocusPoint = vec3(0.0f, 0.0f, 0.0f).xyz;

mat3 getTransformEulerOrientation(const in vec3 transformTargetRotation)
{
    vec3 transformSineRotation = sin(radians(transformTargetRotation.xyz).xyz).xyz;
   
    vec3 transformCosineRotation = cos(radians(transformTargetRotation.xyz).xyz).xyz;
   
    mat3 transformPitchOrientation = mat3(vec3(1.0f, 0.0f, 0.0f).xyz, vec3(0.0f, 1.0f, 0.0f).xyz, vec3(0.0f, 0.0f, 1.0f).xyz);
    transformPitchOrientation[0u].xyz = vec3(1.0f, 0.0f, 0.0f).xyz;
    transformPitchOrientation[1u].xyz = vec3(0.0f, transformCosineRotation.x, -transformSineRotation.x).xyz;
    transformPitchOrientation[2u].xyz = vec3(0.0f, transformSineRotation.x, transformCosineRotation.x).xyz;
   
    mat3 transformYawOrientation = mat3(vec3(1.0f, 0.0f, 0.0f).xyz, vec3(0.0f, 1.0f, 0.0f).xyz, vec3(0.0f, 0.0f, 1.0f).xyz);
    transformYawOrientation[0u].xyz = vec3(transformCosineRotation.y, 0.0f, transformSineRotation.y).xyz;
    transformYawOrientation[1u].xyz = vec3(0.0f, 1.0f, 0.0f).xyz;
    transformYawOrientation[2u].xyz = vec3(-transformSineRotation.y, 0.0f, transformCosineRotation.y).xyz;
   
    mat3 transformRollOrientation = mat3(vec3(1.0f, 0.0f, 0.0f).xyz, vec3(0.0f, 1.0f, 0.0f).xyz, vec3(0.0f, 0.0f, 1.0f).xyz);
    transformRollOrientation[0u].xyz = vec3(transformCosineRotation.z, -transformSineRotation.z, 0.0f).xyz;
    transformRollOrientation[1u].xyz = vec3(transformSineRotation.z, transformCosineRotation.z, 0.0f).xyz;
    transformRollOrientation[2u].xyz = vec3(0.0f, 0.0f, 1.0f).xyz;
   
    mat3 transformEulerOrientation = transformPitchOrientation * transformYawOrientation * transformRollOrientation;
   
    return transformEulerOrientation;
}

mat3 getTransformLookAtOrientation(const in vec3 transformOriginPosition, const in vec3 transformTargetPosition)
{
    vec3 transformForwardDirection = normalize(transformTargetPosition.xyz - transformOriginPosition.xyz).xyz;
   
    vec3 transformRightwardDirection = normalize(cross(vec3(0.0f, 1.0f, 0.0f).xyz, transformForwardDirection.xyz).xyz).xyz;
   
    vec3 transformUpwardDirection = normalize(cross(transformForwardDirection.xyz, transformRightwardDirection.xyz).xyz).xyz;
   
    mat3 transformLookAtOrientation = mat3(-transformRightwardDirection.xyz, transformUpwardDirection.xyz, -transformForwardDirection.xyz);
   
    return transformLookAtOrientation;
}

surface getMixedSurface(const in surface firstSurface, const in surface secondSurface, const in float mixedSurfaceSmoothness)
{
    float surfaceDistanceFactor = clamp(0.5f + 0.5f * (firstSurface.surfaceDistance - secondSurface.surfaceDistance) / mixedSurfaceSmoothness, 0.0f, 1.0f);

    float mixedSurfaceDistance = mix(firstSurface.surfaceDistance, secondSurface.surfaceDistance, surfaceDistanceFactor);
    mixedSurfaceDistance = mixedSurfaceDistance - mixedSurfaceSmoothness * surfaceDistanceFactor * (1.0f - surfaceDistanceFactor);

    float surfaceMaterialFactor = abs(mixedSurfaceDistance - firstSurface.surfaceDistance) + abs(mixedSurfaceDistance - secondSurface.surfaceDistance);
    surfaceMaterialFactor = clamp(abs(mixedSurfaceDistance - firstSurface.surfaceDistance) / max(surfaceMaterialFactor, 0.000001f), 0.0f, 1.0f);

    material mixedSurfaceMaterial;
    mixedSurfaceMaterial.materialAlbedoColor.rgb = mix(firstSurface.surfaceMaterial.materialAlbedoColor.rgb, secondSurface.surfaceMaterial.materialAlbedoColor.rgb, surfaceMaterialFactor).rgb;
    mixedSurfaceMaterial.materialAmbientFactor = mix(firstSurface.surfaceMaterial.materialAmbientFactor, secondSurface.surfaceMaterial.materialAmbientFactor, surfaceMaterialFactor);
    mixedSurfaceMaterial.materialDiffuseFactor = mix(firstSurface.surfaceMaterial.materialDiffuseFactor, secondSurface.surfaceMaterial.materialDiffuseFactor, surfaceMaterialFactor);
    mixedSurfaceMaterial.materialSpecularFactor = mix(firstSurface.surfaceMaterial.materialSpecularFactor, secondSurface.surfaceMaterial.materialSpecularFactor, surfaceMaterialFactor);
    mixedSurfaceMaterial.materialSpecularShininess = mix(firstSurface.surfaceMaterial.materialSpecularShininess, secondSurface.surfaceMaterial.materialSpecularShininess, surfaceMaterialFactor);
    mixedSurfaceMaterial.materialMetallicFactor = mix(firstSurface.surfaceMaterial.materialMetallicFactor, secondSurface.surfaceMaterial.materialMetallicFactor, surfaceMaterialFactor);

    surface mixedSurface = surface(mixedSurfaceDistance, mixedSurfaceMaterial);

    return mixedSurface;
}

surface getCubeSurface(const in vec3 sceneTransformPosition, const in vec3 cubeTransformPosition, const in vec3 cubeTransformRotation, const in vec3 cubeTransformScale, const in float cubeSurfaceRoundness, const in material cubeSurfaceMaterial)
{
    mat3 cubeTransformOrientation = getTransformEulerOrientation(cubeTransformRotation.xyz);
   
    vec3 cubeTransformCoordinates = abs(cubeTransformOrientation * (sceneTransformPosition.xyz - cubeTransformPosition.xyz).xyz).xyz - cubeTransformScale.xyz;
    cubeTransformCoordinates.xyz = cubeTransformCoordinates.xyz + clamp(cubeSurfaceRoundness, 0.0f, min(min(cubeTransformScale.x, cubeTransformScale.y), cubeTransformScale.z));
   
    float cubeSurfaceDistance = length(max(cubeTransformCoordinates.xyz, vec3(0.0f, 0.0f, 0.0f).xyz)) + min(max(max(cubeTransformCoordinates.x, cubeTransformCoordinates.y), cubeTransformCoordinates.z), 0.0f);
    cubeSurfaceDistance = cubeSurfaceDistance - clamp(cubeSurfaceRoundness, 0.0f, min(min(cubeTransformScale.x, cubeTransformScale.y), cubeTransformScale.z));
   
    surface cubeSurface = surface(cubeSurfaceDistance, cubeSurfaceMaterial);
   
    return cubeSurface;
}

surface getSceneSurface(const in vec3 sampleTransformPosition)
{
    surface cube01Surface;
    {
        vec3 cube01TransformPosition = CameraSettingsFocusPoint.xyz + 25.0f * vec3(0.0f, 0.5f * sqrt(3.0f) * 2.0f / 3.0f, 0.0f);
        cube01TransformPosition.x = cube01TransformPosition.x + 10.0f * (sin(0.1f * 1.5707963f * iTime) + sin(0.4f * 1.5707963f * iTime)) / 2.0f;
        cube01TransformPosition.y = cube01TransformPosition.y + 10.0f * (sin(0.5f * 1.5707963f * iTime) + sin(0.8f * 1.5707963f * iTime)) / 2.0f;
        cube01TransformPosition.z = cube01TransformPosition.z + 10.0f * (sin(0.9f * 1.5707963f * iTime) + sin(0.3f * 1.5707963f * iTime)) / 2.0f;
        
        vec3 cube01TransformRotation = vec3(0.0f, 0.0f, 0.0f).xyz;
        cube01TransformRotation.x = cube01TransformRotation.x + 90.0f * (sin(0.1f * 1.5707963f * iTime) + sin(0.4f * 1.5707963f * iTime)) / 2.0f;
        cube01TransformRotation.y = cube01TransformRotation.y + 90.0f * (sin(0.5f * 1.5707963f * iTime) + sin(0.8f * 1.5707963f * iTime)) / 2.0f;
        cube01TransformRotation.z = cube01TransformRotation.z + 90.0f * (sin(0.9f * 1.5707963f * iTime) + sin(0.3f * 1.5707963f * iTime)) / 2.0f;
        
        vec3 cube01TransformScale = vec3(10.0f, 10.0f, 10.0f).xyz;
        
        float cube01SurfaceRoundness = 2.5f;
        
        material cube01SurfaceMaterial = material(vec3(1.0f, 0.0f, 0.0f).rgb, 0.25f, 0.75f, 1.0f, 100.0f, 0.0f);
        
        cube01Surface = getCubeSurface(sampleTransformPosition.xyz, cube01TransformPosition.xyz, cube01TransformRotation.xyz, cube01TransformScale.xyz, cube01SurfaceRoundness, cube01SurfaceMaterial);
    }
    
    surface cube02Surface;
    {
        vec3 cube02TransformPosition = CameraSettingsFocusPoint.xyz + 25.0f * vec3(-0.5f, -0.5f * sqrt(3.0f) / 3.0f, 0.0f).xyz;
        cube02TransformPosition.x = cube02TransformPosition.x + 10.0f * (sin(0.4f * 1.5707963f * iTime) + sin(0.7f * 1.5707963f * iTime)) / 2.0f;
        cube02TransformPosition.y = cube02TransformPosition.y + 10.0f * (sin(0.8f * 1.5707963f * iTime) + sin(0.2f * 1.5707963f * iTime)) / 2.0f;
        cube02TransformPosition.z = cube02TransformPosition.z + 10.0f * (sin(0.3f * 1.5707963f * iTime) + sin(0.6f * 1.5707963f * iTime)) / 2.0f;
        
        vec3 cube02TransformRotation = vec3(0.0f, 0.0f, 0.0f).xyz;
        cube02TransformRotation.x = cube02TransformRotation.x + 90.0f * (sin(0.4f * 1.5707963f * iTime) + sin(0.7f * 1.5707963f * iTime)) / 2.0f;
        cube02TransformRotation.y = cube02TransformRotation.y + 90.0f * (sin(0.8f * 1.5707963f * iTime) + sin(0.2f * 1.5707963f * iTime)) / 2.0f;
        cube02TransformRotation.z = cube02TransformRotation.z + 90.0f * (sin(0.3f * 1.5707963f * iTime) + sin(0.6f * 1.5707963f * iTime)) / 2.0f;
        
        vec3 cube02TransformScale = vec3(10.0f, 10.0f, 10.0f).xyz;
        
        float cube02SurfaceRoundness = 2.5f;
        
        material cube02SurfaceMaterial = material(vec3(0.0f, 1.0f, 0.0f).rgb, 0.25f, 0.75f, 1.0f, 100.0f, 0.0f);
        
        cube02Surface = getCubeSurface(sampleTransformPosition.xyz, cube02TransformPosition.xyz, cube02TransformRotation.xyz, cube02TransformScale.xyz, cube02SurfaceRoundness, cube02SurfaceMaterial);
    }
    
    surface cube03Surface;
    {
        vec3 cube03TransformPosition = CameraSettingsFocusPoint.xyz + 25.0f * vec3(0.5f, -0.5f * sqrt(3.0f) / 3.0f, 0.0f).xyz;
        cube03TransformPosition.x = cube03TransformPosition.x + 10.0f * (sin(0.7f * 1.5707963f * iTime) + sin(0.1f * 1.5707963f * iTime)) / 2.0f;
        cube03TransformPosition.y = cube03TransformPosition.y + 10.0f * (sin(0.2f * 1.5707963f * iTime) + sin(0.5f * 1.5707963f * iTime)) / 2.0f;
        cube03TransformPosition.z = cube03TransformPosition.z + 10.0f * (sin(0.6f * 1.5707963f * iTime) + sin(0.9f * 1.5707963f * iTime)) / 2.0f;
        
        vec3 cube03TransformRotation = vec3(0.0f, 0.0f, 0.0f).xyz;
        cube03TransformRotation.x = cube03TransformRotation.x + 90.0f * (sin(0.7f * 1.5707963f * iTime) + sin(0.1f * 1.5707963f * iTime)) / 2.0f;
        cube03TransformRotation.y = cube03TransformRotation.y + 90.0f * (sin(0.2f * 1.5707963f * iTime) + sin(0.5f * 1.5707963f * iTime)) / 2.0f;
        cube03TransformRotation.z = cube03TransformRotation.z + 90.0f * (sin(0.6f * 1.5707963f * iTime) + sin(0.9f * 1.5707963f * iTime)) / 2.0f;
        
        vec3 cube03TransformScale = vec3(10.0f, 10.0f, 10.0f).xyz;
        
        float cube03SurfaceRoundness = 2.5f;
        
        material cube03SurfaceMaterial = material(vec3(0.0f, 0.0f, 1.0f).rgb, 0.25f, 0.75f, 1.0f, 100.0f, 0.0f);
        
        cube03Surface = getCubeSurface(sampleTransformPosition.xyz, cube03TransformPosition.xyz, cube03TransformRotation.xyz, cube03TransformScale.xyz, cube03SurfaceRoundness, cube03SurfaceMaterial);
    }
    
    surface sceneSurface = cube01Surface;
    sceneSurface = getMixedSurface(sceneSurface, cube02Surface, 10.0f);
    sceneSurface = getMixedSurface(sceneSurface, cube03Surface, 10.0f);
   
    return sceneSurface;
}

surface getRaymarchSurface(const in vec3 sampleTransformPosition, const in vec3 sampleTransformDirection)
{
    float raymarchSurfaceDistance = 0.0f;
   
    surface raymarchSurface;
    raymarchSurface.surfaceDistance = raymarchSurfaceDistance;
   
    const float RaymarchSurfaceIterator = 100.0f;
   
    const float RaymarchSurfaceMinimumDistance = 0.0001f;
    const float RaymarchSurfaceMaximumDistance = 500.0f;
   
    for (float raymarchSurfaceCounter = 0.0f; raymarchSurfaceCounter < RaymarchSurfaceIterator; ++raymarchSurfaceCounter)
    {
        raymarchSurface = getSceneSurface(sampleTransformPosition.xyz + raymarchSurfaceDistance * sampleTransformDirection.xyz);
       
        if (raymarchSurface.surfaceDistance < RaymarchSurfaceMinimumDistance || raymarchSurfaceDistance > RaymarchSurfaceMaximumDistance) break;
       
        raymarchSurfaceDistance = raymarchSurfaceDistance + raymarchSurface.surfaceDistance;
    }
   
    raymarchSurface.surfaceDistance = raymarchSurfaceDistance;
   
    return raymarchSurface;
}

void setFragmentForegroundColor(inout vec3 fragmentOutputColor, const in vec3 cameraTransformPosition, const in vec3 cameraTransformDirection, const in vec3 surfaceTransformPosition, const in vec3 surfaceTransformDirection, const in pointlight pointlight, const in material surfaceMaterial)
{
   vec3 observerTransformDirection = normalize(cameraTransformPosition.xyz - surfaceTransformPosition.xyz).xyz;
   observerTransformDirection = (length(observerTransformDirection.xyz) > 0.000001f ? observerTransformDirection.xyz : cameraTransformDirection.xyz).xyz;
   
   vec3 lightingTransformDirection = normalize(pointlight.pointlightTransformPosition.xyz - surfaceTransformPosition.xyz).xyz;
   
   vec3 brightnessTransformDirection = normalize(observerTransformDirection.xyz + lightingTransformDirection.xyz).xyz;
   brightnessTransformDirection.xyz = (length(brightnessTransformDirection.xyz) > 0.000001f ? brightnessTransformDirection.xyz : lightingTransformDirection.xyz).xyz;
   
   float pointlightEmissiveDistance = length(pointlight.pointlightTransformPosition.xyz - surfaceTransformPosition.xyz);
   
   float pointlightAttenuationFactor = clamp(pointlightEmissiveDistance / pointlight.pointlightEmissiveRange, 0.0f, 1.0f);
   pointlightAttenuationFactor = 1.0f - pointlightAttenuationFactor * pointlightAttenuationFactor;
   pointlightAttenuationFactor = pointlightAttenuationFactor * pointlightAttenuationFactor;
   
   float surfaceMaterialAmbientStrength = clamp(0.5f + 0.5f * dot(surfaceTransformDirection.xyz, lightingTransformDirection.xyz), 0.0f, 1.0f);
   surfaceMaterialAmbientStrength = surfaceMaterialAmbientStrength * clamp(surfaceMaterial.materialAmbientFactor, 0.0f, 1.0f);
   surfaceMaterialAmbientStrength = surfaceMaterialAmbientStrength * clamp(pointlight.pointlightEmissiveFactor, 0.0f, 1.0f);
   surfaceMaterialAmbientStrength = surfaceMaterialAmbientStrength * clamp(pointlightAttenuationFactor, 0.0f, 1.0f);
   
   float surfaceMaterialDiffuseStrength = clamp(dot(surfaceTransformDirection.xyz, lightingTransformDirection.xyz), 0.0f, 1.0f);
   surfaceMaterialDiffuseStrength = surfaceMaterialDiffuseStrength * clamp(surfaceMaterial.materialDiffuseFactor, 0.0f, 1.0f);
   surfaceMaterialDiffuseStrength = surfaceMaterialDiffuseStrength * clamp(pointlight.pointlightEmissiveFactor, 0.0f, 1.0f);
   surfaceMaterialDiffuseStrength = surfaceMaterialDiffuseStrength * clamp(pointlightAttenuationFactor, 0.0f, 1.0f);
   
   const float SurfaceMaterialSpecularMinimumPower = 0.0f;
   const float SurfaceMaterialSpecularMaximumPower = 100.0f;
   float surfaceMaterialSpecularPower = clamp(surfaceMaterial.materialSpecularShininess, SurfaceMaterialSpecularMinimumPower, SurfaceMaterialSpecularMaximumPower);
   float surfaceMaterialSpecularStrength = clamp(dot(surfaceTransformDirection.xyz, brightnessTransformDirection.xyz), 0.0f, 1.0f);
   surfaceMaterialSpecularStrength = pow(surfaceMaterialSpecularStrength, surfaceMaterialSpecularPower);
   surfaceMaterialSpecularStrength = surfaceMaterialSpecularStrength * clamp(surfaceMaterial.materialSpecularFactor, 0.0f, 1.0f);
   surfaceMaterialSpecularStrength = surfaceMaterialSpecularStrength * clamp(pointlight.pointlightEmissiveFactor, 0.0f, 1.0f);
   surfaceMaterialSpecularStrength = surfaceMaterialSpecularStrength * clamp(pointlightAttenuationFactor, 0.0f, 1.0f);
   
   vec3 surfaceMaterialAmbientColor = clamp(surfaceMaterial.materialAlbedoColor.rgb, vec3(0.0f, 0.0f, 0.0f).rgb, vec3(1.0f, 1.0f, 1.0f).rgb).rgb;
   surfaceMaterialAmbientColor.rgb = mix(surfaceMaterialAmbientColor.rgb, vec3(0.0f, 0.0f, 0.0f).rgb, clamp(surfaceMaterial.materialMetallicFactor, 0.0f, 1.0f)).rgb;
   surfaceMaterialAmbientColor.rgb = surfaceMaterialAmbientColor.rgb * clamp(pointlight.pointlightEmissiveColor.rgb, vec3(0.0f, 0.0f, 0.0f).rgb, vec3(1.0f, 1.0f, 1.0f).rgb).rgb;
   surfaceMaterialAmbientColor.rgb = surfaceMaterialAmbientColor.rgb * surfaceMaterialAmbientStrength;
   
   vec3 surfaceMaterialDiffuseColor = clamp(surfaceMaterial.materialAlbedoColor.rgb, vec3(0.0f, 0.0f, 0.0f).rgb, vec3(1.0f, 1.0f, 1.0f).rgb).rgb;
   surfaceMaterialDiffuseColor.rgb = mix(surfaceMaterialDiffuseColor.rgb, vec3(0.0f, 0.0f, 0.0f).rgb, clamp(surfaceMaterial.materialMetallicFactor, 0.0f, 1.0f)).rgb;
   surfaceMaterialDiffuseColor.rgb = surfaceMaterialDiffuseColor.rgb * clamp(pointlight.pointlightEmissiveColor.rgb, vec3(0.0f, 0.0f, 0.0f).rgb, vec3(1.0f, 1.0f, 1.0f).rgb).rgb;
   surfaceMaterialDiffuseColor.rgb = surfaceMaterialDiffuseColor.rgb * surfaceMaterialDiffuseStrength;
   
   vec3 surfaceMaterialSpecularColor = clamp(surfaceMaterial.materialAlbedoColor.rgb, vec3(0.0f, 0.0f, 0.0f).rgb, vec3(1.0f, 1.0f, 1.0f).rgb).rgb;
   surfaceMaterialSpecularColor.rgb = mix(vec3(1.0f, 1.0f, 1.0f).rgb, surfaceMaterialSpecularColor.rgb, clamp(surfaceMaterial.materialMetallicFactor, 0.0f, 1.0f)).rgb;
   surfaceMaterialSpecularColor.rgb = surfaceMaterialSpecularColor.rgb * clamp(pointlight.pointlightEmissiveColor.rgb, vec3(0.0f, 0.0f, 0.0f).rgb, vec3(1.0f, 1.0f, 1.0f).rgb).rgb;
   surfaceMaterialSpecularColor.rgb = surfaceMaterialSpecularColor.rgb * surfaceMaterialSpecularStrength;
   
   vec3 surfaceMaterialCompleteColor = vec3(0.0f, 0.0f, 0.0f).rgb;
   surfaceMaterialCompleteColor.rgb = surfaceMaterialCompleteColor.rgb + surfaceMaterialAmbientColor.rgb;
   surfaceMaterialCompleteColor.rgb = surfaceMaterialCompleteColor.rgb + surfaceMaterialDiffuseColor.rgb;
   surfaceMaterialCompleteColor.rgb = surfaceMaterialCompleteColor.rgb + surfaceMaterialSpecularColor.rgb;
   
   fragmentOutputColor.rgb = fragmentOutputColor.rgb + surfaceMaterialCompleteColor.rgb;
}

void setFragmentForegroundColor(inout vec3 fragmentOutputColor, const in vec3 cameraTransformPosition, const in vec3 cameraTransformDirection, const in surface raymarchSurface)
{
    vec3 surfaceTransformPosition = cameraTransformPosition.xyz + raymarchSurface.surfaceDistance * cameraTransformDirection.xyz;
   
    vec3 surfaceTransformDirection = vec3(0.0f, 0.0f, 0.0f).xyz;
    surfaceTransformDirection.x = getSceneSurface(surfaceTransformPosition.xyz + vec3(0.0001f, 0.0f, 0.0f).xyz).surfaceDistance - getSceneSurface(surfaceTransformPosition.xyz - vec3(0.0001f, 0.0f, 0.0f).xyz).surfaceDistance;
    surfaceTransformDirection.y = getSceneSurface(surfaceTransformPosition.xyz + vec3(0.0f, 0.0001f, 0.0f).xyz).surfaceDistance - getSceneSurface(surfaceTransformPosition.xyz - vec3(0.0f, 0.0001f, 0.0f).xyz).surfaceDistance;
    surfaceTransformDirection.z = getSceneSurface(surfaceTransformPosition.xyz + vec3(0.0f, 0.0f, 0.0001f).xyz).surfaceDistance - getSceneSurface(surfaceTransformPosition.xyz - vec3(0.0f, 0.0f, 0.0001f).xyz).surfaceDistance;
    surfaceTransformDirection.xyz = normalize(surfaceTransformDirection.xyz).xyz;
   
    pointlight pointlight01 = pointlight(vec3(-50.0f, 50.0f, -50.0f).xyz, vec3(1.0f, 1.0f, 1.0f).rgb, 1.0f, 100.0f);
   
    setFragmentForegroundColor(fragmentOutputColor.rgb, cameraTransformPosition.xyz, cameraTransformDirection.xyz, surfaceTransformPosition.xyz, surfaceTransformDirection.xyz, pointlight01, raymarchSurface.surfaceMaterial);
   
    pointlight pointlight02 = pointlight(vec3(-50.0f, 50.0f, 50.0f).xyz, vec3(1.0f, 1.0f, 1.0f).rgb, 1.0f, 100.0f);
   
    setFragmentForegroundColor(fragmentOutputColor.rgb, cameraTransformPosition.xyz, cameraTransformDirection.xyz, surfaceTransformPosition.xyz, surfaceTransformDirection.xyz, pointlight02, raymarchSurface.surfaceMaterial);
   
    pointlight pointlight03 = pointlight(vec3(50.0f, 50.0f, -50.0f).xyz, vec3(1.0f, 1.0f, 1.0f).rgb, 1.0f, 100.0f);
   
    setFragmentForegroundColor(fragmentOutputColor.rgb, cameraTransformPosition.xyz, cameraTransformDirection.xyz, surfaceTransformPosition.xyz, surfaceTransformDirection.xyz, pointlight03, raymarchSurface.surfaceMaterial);
   
    pointlight pointlight04 = pointlight(vec3(50.0f, 50.0f, 50.0f).xyz, vec3(1.0f, 1.0f, 1.0f).rgb, 1.0f, 100.0f);
   
    setFragmentForegroundColor(fragmentOutputColor.rgb, cameraTransformPosition.xyz, cameraTransformDirection.xyz, surfaceTransformPosition.xyz, surfaceTransformDirection.xyz, pointlight04, raymarchSurface.surfaceMaterial);
}

void setFragmentBackgroundColor(inout vec3 fragmentOutputColor, const in vec2 fragmentInputCoordinates, const in vec3 fragmentTileEvenColor, const in vec3 fragmentTileOddColor, const in float fragmentTileDimension, const in vec3 fragmentLineColor, const in float fragmentLineDimension)
{
    vec2 fragmentOffsetCoordinates = (iResolution.x < iResolution.y ? vec2(1.0f, 0.0f).xy : iResolution.x > iResolution.y ? vec2(0.0f, 1.0f).xy : vec2(0.0f, 0.0f).xy).xy;
   
    vec2 fragmentTileCoordinates = (2.0f * fragmentInputCoordinates.xy - iResolution.xy).xy / min(iResolution.x, iResolution.y);
    fragmentTileCoordinates.xy = fragmentTileCoordinates.xy + vec2(fragmentTileDimension, fragmentTileDimension).xy * fragmentOffsetCoordinates.xy;
    fragmentTileCoordinates.xy = floor(fragmentTileCoordinates.xy / vec2(fragmentTileDimension, fragmentTileDimension).xy).xy;
   
    float fragmentTileChecker = step(fragmentTileDimension, mod(fragmentTileCoordinates.x + fragmentTileCoordinates.y, 2.0f));
   
    fragmentOutputColor.rgb = mix(fragmentTileEvenColor.rgb, fragmentTileOddColor.rgb, fragmentTileChecker).rgb;
   
    vec2 fragmentLineCoordinates = (2.0f * fragmentInputCoordinates.xy - iResolution.xy).xy / min(iResolution.x, iResolution.y);
    fragmentLineCoordinates.xy = fragmentLineCoordinates.xy + vec2(fragmentTileDimension, fragmentTileDimension).xy * fragmentOffsetCoordinates.xy;
    fragmentLineCoordinates.xy = mod(fragmentLineCoordinates.xy, vec2(fragmentTileDimension, fragmentTileDimension).xy).xy;
    fragmentLineCoordinates.xy = min(fragmentLineCoordinates.xy, vec2(fragmentTileDimension, fragmentTileDimension).xy - fragmentLineCoordinates.xy).xy;
   
    float fragmentLineChecker = step(min(fragmentLineCoordinates.x, fragmentLineCoordinates.y), fragmentLineDimension);
   
    fragmentOutputColor.rgb = mix(fragmentOutputColor.rgb, fragmentLineColor.rgb, fragmentLineChecker).rgb;
}

void setVignetteImageProcessing(inout vec3 fragmentOutputColor, const in vec2 fragmentInputCoordinates, const in vec3 vignetteSurfaceColor, const in float vignetteTransformScale, const in float vignetteSurfaceRoundness, const in float vignetteSurfaceSmoothness)
{
    vec2 vignetteTransformPosition = abs((2.0f * fragmentInputCoordinates.xy - iResolution.xy).xy / iResolution.xy).xy;
    vignetteTransformPosition.xy = vignetteTransformPosition.xy - vec2(vignetteTransformScale * (1.0f - vignetteSurfaceRoundness), vignetteTransformScale * (1.0f - vignetteSurfaceRoundness)).xy;
   
    float vignetteSurfaceDistance = length(max(vignetteTransformPosition.xy, vec2(0.0f, 0.0f).xy).xy) + min(max(vignetteTransformPosition.x, vignetteTransformPosition.y), 0.0f);
    vignetteSurfaceDistance = smoothstep(0.0f, vignetteSurfaceSmoothness, vignetteSurfaceDistance - vignetteTransformScale * vignetteSurfaceRoundness);
   
    fragmentOutputColor.rgb = mix(fragmentOutputColor.rgb, vignetteSurfaceColor.rgb, vignetteSurfaceDistance).rgb;
}

void setGammaCorrectionImageProcessing(inout vec3 fragmentOutputColor, const in float gammaCorrectionExponent)
{
    vec3 gammaCorrectionColor = vec3(gammaCorrectionExponent, gammaCorrectionExponent, gammaCorrectionExponent).rgb;
   
    fragmentOutputColor.rgb = pow(fragmentOutputColor.rgb, gammaCorrectionColor.rgb).rgb;
}

void mainImage(out vec4 fragmentOutputColor, in vec2 fragmentInputCoordinates)
{
    fragmentOutputColor.rgba = vec4(0.0f, 0.0f, 0.0f, 1.0f).rgba;
   
    vec3 cameraTransformPosition = vec3(0.0f, 0.0f, 0.0f).xyz;
    {
        vec3 cameraSettingsOrbitalAxis = vec3(radians(45.0f), radians(45.0f), 50.0f).xyz;
        
        vec3 cameraSettingsOrbitalPoint = vec3(0.0f, 0.0f, 0.0f).xyz;
        cameraSettingsOrbitalPoint.x = cameraSettingsOrbitalAxis.z * cos(cameraSettingsOrbitalAxis.y) * cos(cameraSettingsOrbitalAxis.x + iTime);
        cameraSettingsOrbitalPoint.y = cameraSettingsOrbitalAxis.z * sin(cameraSettingsOrbitalAxis.y);
        cameraSettingsOrbitalPoint.z = cameraSettingsOrbitalAxis.z * cos(cameraSettingsOrbitalAxis.y) * sin(cameraSettingsOrbitalAxis.x + iTime);
        
        cameraTransformPosition.xyz = CameraSettingsFocusPoint.xyz + cameraSettingsOrbitalPoint.xyz;
    }
   
    vec3 cameraTransformDirection = vec3(0.0f, 0.0f, 0.0f).xyz;
    {
        mat3 cameraTransformOrientation = getTransformLookAtOrientation(cameraTransformPosition.xyz, CameraSettingsFocusPoint.xyz);
       
        vec2 cameraSettingsViewport = (2.0f * fragmentInputCoordinates.xy - iResolution.xy).xy / min(iResolution.x, iResolution.y);
       
        const float CameraSettingsMinimumFieldOfView = 10.0f;
        const float CameraSettingsMaximumFieldOfView = 170.0f;
        float cameraSettingsFieldOfView = clamp(60.0f, CameraSettingsMinimumFieldOfView, CameraSettingsMaximumFieldOfView);
       
        float cameraSettingsFocalLength = 1.0f / tan(0.5f * radians(cameraSettingsFieldOfView));
       
        cameraTransformDirection.xyz = cameraTransformOrientation * normalize(vec3(cameraSettingsViewport.x, cameraSettingsViewport.y, -cameraSettingsFocalLength).xyz).xyz;
    }
   
    surface raymarchSurface = getRaymarchSurface(cameraTransformPosition.xyz, cameraTransformDirection.xyz);
   
    const float CameraSettingsNearClippingPlane = 0.0001f;
    const float CameraSettingsFarClippingPlane = 500.0f;
   
    if (raymarchSurface.surfaceDistance < CameraSettingsNearClippingPlane || raymarchSurface.surfaceDistance > CameraSettingsFarClippingPlane)
    {
        setFragmentBackgroundColor(fragmentOutputColor.rgb, fragmentInputCoordinates.xy, vec3(1.0f / 20.0f, 1.0f / 20.0f, 1.0f / 20.0f).rgb, vec3(1.0f / 10.0f, 1.0f / 10.0f, 1.0f / 10.0f).rgb, 0.25f, vec3(1.0f / 100.0f, 1.0f / 100.0f, 1.0f / 100.0f).rgb, 0.005f);
    }
    else
    {
        setFragmentForegroundColor(fragmentOutputColor.rgb, cameraTransformPosition.xyz, cameraTransformDirection.xyz, raymarchSurface);
    }
   
    setVignetteImageProcessing(fragmentOutputColor.rgb, fragmentInputCoordinates.xy, vec3(1.0f / 100.0f, 1.0f / 100.0f, 1.0f / 100.0f).rgb, 0.5f, 0.5f, 0.5f);
   
    setGammaCorrectionImageProcessing(fragmentOutputColor.rgb, 1.0f / 2.2f);
    
    fragmentOutputColor.rgba = vec4(fragmentOutputColor.r, fragmentOutputColor.g, fragmentOutputColor.b, 1.0f);
}
