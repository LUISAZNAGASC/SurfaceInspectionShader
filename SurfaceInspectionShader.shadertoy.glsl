// LAST UPDATED DATE : 12/06/2025

// SHADERTOY IMAGE

#define ImageProcessing_Passthrough 0u
#define ImageProcessing_GaussianBlur 1u
#define ImageProcessing_EdgeDetection 2u

#define ImageProcessing_WindowLeftSide ImageProcessing_Passthrough
#define ImageProcessing_WindowRightSide ImageProcessing_EdgeDetection

void setGaussianBlurImageProcessing(inout vec4 fragmentOutputColor, const in vec2 fragmentPixelCoordinates)
{
    const float GaussianBlurDownscale = 32.0f;
    
    vec2 fragmentTextureDimension = GaussianBlurDownscale / iChannelResolution[0u].xy;
    
    vec4 gaussianBlurAccumulatedColor;
    gaussianBlurAccumulatedColor.rgba += 0.0039062f * texture(iChannel0, vec2(-2.0f, -2.0f).xy * fragmentTextureDimension.xy + fragmentPixelCoordinates.xy).rgba;
    gaussianBlurAccumulatedColor.rgba += 0.0156250f * texture(iChannel0, vec2(-1.0f, -2.0f).xy * fragmentTextureDimension.xy + fragmentPixelCoordinates.xy).rgba;
    gaussianBlurAccumulatedColor.rgba += 0.0234375f * texture(iChannel0, vec2(+0.0f, -2.0f).xy * fragmentTextureDimension.xy + fragmentPixelCoordinates.xy).rgba;
    gaussianBlurAccumulatedColor.rgba += 0.0156250f * texture(iChannel0, vec2(+1.0f, -2.0f).xy * fragmentTextureDimension.xy + fragmentPixelCoordinates.xy).rgba;
    gaussianBlurAccumulatedColor.rgba += 0.0039062f * texture(iChannel0, vec2(+2.0f, -2.0f).xy * fragmentTextureDimension.xy + fragmentPixelCoordinates.xy).rgba;
    gaussianBlurAccumulatedColor.rgba += 0.0156250f * texture(iChannel0, vec2(-2.0f, -1.0f).xy * fragmentTextureDimension.xy + fragmentPixelCoordinates.xy).rgba;
    gaussianBlurAccumulatedColor.rgba += 0.0625000f * texture(iChannel0, vec2(-1.0f, -1.0f).xy * fragmentTextureDimension.xy + fragmentPixelCoordinates.xy).rgba;
    gaussianBlurAccumulatedColor.rgba += 0.0937500f * texture(iChannel0, vec2(+0.0f, -1.0f).xy * fragmentTextureDimension.xy + fragmentPixelCoordinates.xy).rgba;
    gaussianBlurAccumulatedColor.rgba += 0.0625000f * texture(iChannel0, vec2(+1.0f, -1.0f).xy * fragmentTextureDimension.xy + fragmentPixelCoordinates.xy).rgba;
    gaussianBlurAccumulatedColor.rgba += 0.0156250f * texture(iChannel0, vec2(+2.0f, -1.0f).xy * fragmentTextureDimension.xy + fragmentPixelCoordinates.xy).rgba;
    gaussianBlurAccumulatedColor.rgba += 0.0234375f * texture(iChannel0, vec2(-2.0f, +0.0f).xy * fragmentTextureDimension.xy + fragmentPixelCoordinates.xy).rgba;
    gaussianBlurAccumulatedColor.rgba += 0.0937500f * texture(iChannel0, vec2(-1.0f, +0.0f).xy * fragmentTextureDimension.xy + fragmentPixelCoordinates.xy).rgba;
    gaussianBlurAccumulatedColor.rgba += 0.1406250f * texture(iChannel0, vec2(+0.0f, +0.0f).xy * fragmentTextureDimension.xy + fragmentPixelCoordinates.xy).rgba;
    gaussianBlurAccumulatedColor.rgba += 0.0937500f * texture(iChannel0, vec2(+1.0f, +0.0f).xy * fragmentTextureDimension.xy + fragmentPixelCoordinates.xy).rgba;
    gaussianBlurAccumulatedColor.rgba += 0.0234375f * texture(iChannel0, vec2(+2.0f, +0.0f).xy * fragmentTextureDimension.xy + fragmentPixelCoordinates.xy).rgba;
    gaussianBlurAccumulatedColor.rgba += 0.0156250f * texture(iChannel0, vec2(-2.0f, +1.0f).xy * fragmentTextureDimension.xy + fragmentPixelCoordinates.xy).rgba;
    gaussianBlurAccumulatedColor.rgba += 0.0625000f * texture(iChannel0, vec2(-1.0f, +1.0f).xy * fragmentTextureDimension.xy + fragmentPixelCoordinates.xy).rgba;
    gaussianBlurAccumulatedColor.rgba += 0.0937500f * texture(iChannel0, vec2(+0.0f, +1.0f).xy * fragmentTextureDimension.xy + fragmentPixelCoordinates.xy).rgba;
    gaussianBlurAccumulatedColor.rgba += 0.0625000f * texture(iChannel0, vec2(+1.0f, +1.0f).xy * fragmentTextureDimension.xy + fragmentPixelCoordinates.xy).rgba;
    gaussianBlurAccumulatedColor.rgba += 0.0156250f * texture(iChannel0, vec2(+2.0f, +1.0f).xy * fragmentTextureDimension.xy + fragmentPixelCoordinates.xy).rgba;
    gaussianBlurAccumulatedColor.rgba += 0.0039062f * texture(iChannel0, vec2(-2.0f, +2.0f).xy * fragmentTextureDimension.xy + fragmentPixelCoordinates.xy).rgba;
    gaussianBlurAccumulatedColor.rgba += 0.0156250f * texture(iChannel0, vec2(-1.0f, +2.0f).xy * fragmentTextureDimension.xy + fragmentPixelCoordinates.xy).rgba;
    gaussianBlurAccumulatedColor.rgba += 0.0234375f * texture(iChannel0, vec2(+0.0f, +2.0f).xy * fragmentTextureDimension.xy + fragmentPixelCoordinates.xy).rgba;
    gaussianBlurAccumulatedColor.rgba += 0.0156250f * texture(iChannel0, vec2(+1.0f, +2.0f).xy * fragmentTextureDimension.xy + fragmentPixelCoordinates.xy).rgba;
    gaussianBlurAccumulatedColor.rgba += 0.0039062f * texture(iChannel0, vec2(+2.0f, +2.0f).xy * fragmentTextureDimension.xy + fragmentPixelCoordinates.xy).rgba;
    
    fragmentOutputColor.rgba = gaussianBlurAccumulatedColor.rgba;
}

void setEdgeDetectionImageProcessing(inout vec4 fragmentOutputColor, const in vec2 fragmentPixelCoordinates)
{
    const float EdgeDetectionDownscale = 1.0f;
    
    vec2 fragmentTextureDimension = EdgeDetectionDownscale / iChannelResolution[0u].xy;
    
    vec4 edgeDetectionHorizontalGradient;
    edgeDetectionHorizontalGradient.rgba += -1.0f * texture(iChannel0, vec2(-1.0f, -1.0f).xy * fragmentTextureDimension.xy + fragmentPixelCoordinates.xy).rgba;
    edgeDetectionHorizontalGradient.rgba += +0.0f * texture(iChannel0, vec2(+0.0f, -1.0f).xy * fragmentTextureDimension.xy + fragmentPixelCoordinates.xy).rgba;
    edgeDetectionHorizontalGradient.rgba += +1.0f * texture(iChannel0, vec2(+1.0f, -1.0f).xy * fragmentTextureDimension.xy + fragmentPixelCoordinates.xy).rgba;
    edgeDetectionHorizontalGradient.rgba += -2.0f * texture(iChannel0, vec2(-1.0f, +0.0f).xy * fragmentTextureDimension.xy + fragmentPixelCoordinates.xy).rgba;
    edgeDetectionHorizontalGradient.rgba += +0.0f * texture(iChannel0, vec2(+0.0f, +0.0f).xy * fragmentTextureDimension.xy + fragmentPixelCoordinates.xy).rgba;
    edgeDetectionHorizontalGradient.rgba += +2.0f * texture(iChannel0, vec2(+1.0f, +0.0f).xy * fragmentTextureDimension.xy + fragmentPixelCoordinates.xy).rgba;
    edgeDetectionHorizontalGradient.rgba += -1.0f * texture(iChannel0, vec2(-1.0f, +1.0f).xy * fragmentTextureDimension.xy + fragmentPixelCoordinates.xy).rgba;
    edgeDetectionHorizontalGradient.rgba += +0.0f * texture(iChannel0, vec2(+0.0f, +1.0f).xy * fragmentTextureDimension.xy + fragmentPixelCoordinates.xy).rgba;
    edgeDetectionHorizontalGradient.rgba += +1.0f * texture(iChannel0, vec2(+1.0f, +1.0f).xy * fragmentTextureDimension.xy + fragmentPixelCoordinates.xy).rgba;
    
    float edgeDetectionHorizontalIntensity = length(edgeDetectionHorizontalGradient.rgba);
    
    vec4 edgeDetectionVerticalGradient;
    edgeDetectionVerticalGradient.rgba += +1.0f * texture(iChannel0, vec2(-1.0f, -1.0f).xy * fragmentTextureDimension.xy + fragmentPixelCoordinates.xy).rgba;
    edgeDetectionVerticalGradient.rgba += +2.0f * texture(iChannel0, vec2(+0.0f, -1.0f).xy * fragmentTextureDimension.xy + fragmentPixelCoordinates.xy).rgba;
    edgeDetectionVerticalGradient.rgba += +1.0f * texture(iChannel0, vec2(+1.0f, -1.0f).xy * fragmentTextureDimension.xy + fragmentPixelCoordinates.xy).rgba;
    edgeDetectionVerticalGradient.rgba += +0.0f * texture(iChannel0, vec2(-1.0f, +0.0f).xy * fragmentTextureDimension.xy + fragmentPixelCoordinates.xy).rgba;
    edgeDetectionVerticalGradient.rgba += +0.0f * texture(iChannel0, vec2(+0.0f, +0.0f).xy * fragmentTextureDimension.xy + fragmentPixelCoordinates.xy).rgba;
    edgeDetectionVerticalGradient.rgba += +0.0f * texture(iChannel0, vec2(+1.0f, +0.0f).xy * fragmentTextureDimension.xy + fragmentPixelCoordinates.xy).rgba;
    edgeDetectionVerticalGradient.rgba += -1.0f * texture(iChannel0, vec2(-1.0f, +1.0f).xy * fragmentTextureDimension.xy + fragmentPixelCoordinates.xy).rgba;
    edgeDetectionVerticalGradient.rgba += -2.0f * texture(iChannel0, vec2(+0.0f, +1.0f).xy * fragmentTextureDimension.xy + fragmentPixelCoordinates.xy).rgba;
    edgeDetectionVerticalGradient.rgba += -1.0f * texture(iChannel0, vec2(+1.0f, +1.0f).xy * fragmentTextureDimension.xy + fragmentPixelCoordinates.xy).rgba;
    
    float edgeDetectionVerticalIntensity = length(edgeDetectionVerticalGradient.rgba);
    
    float edgeDetectionAllInOneIntensity = length(vec2(edgeDetectionHorizontalIntensity, edgeDetectionVerticalIntensity).xy);
    
    fragmentOutputColor.rgba = vec4(edgeDetectionAllInOneIntensity).rgba;
}

void mainImage(out vec4 fragmentOutputColor, in vec2 fragmentInputCoordinates)
{
    vec2 fragmentPixelCoordinates = fragmentInputCoordinates.xy / iChannelResolution[0u].xy;
    
    float mouseInputHorizontalSlider = clamp(iMouse.z >= 1.0f ? iMouse.x / iChannelResolution[0u].x : 0.5f, 0.0f, 1.0f);
    
    if (fragmentPixelCoordinates.x <= mouseInputHorizontalSlider)
    {
        #if ImageProcessing_WindowLeftSide == ImageProcessing_Passthrough
        fragmentOutputColor.rgba = texture(iChannel0, fragmentPixelCoordinates.xy).rgba;
        #elif ImageProcessing_WindowLeftSide == ImageProcessing_GaussianBlur
        setGaussianBlurImageProcessing(fragmentOutputColor.rgba, fragmentPixelCoordinates.xy);
        #elif ImageProcessing_WindowLeftSide == ImageProcessing_EdgeDetection
        setEdgeDetectionImageProcessing(fragmentOutputColor.rgba, fragmentPixelCoordinates.xy);
        #else
        fragmentOutputColor.rgba = vec4(1.0f, 0.0f, 1.0f, 1.0f).rgba;
        #endif
    }
    else if (fragmentPixelCoordinates.x >= mouseInputHorizontalSlider)
    {
        #if ImageProcessing_WindowRightSide == ImageProcessing_Passthrough
        fragmentOutputColor.rgba = texture(iChannel0, fragmentPixelCoordinates.xy).rgba;
        #elif ImageProcessing_WindowRightSide == ImageProcessing_GaussianBlur
        setGaussianBlurImageProcessing(fragmentOutputColor.rgba, fragmentPixelCoordinates.xy);
        #elif ImageProcessing_WindowRightSide == ImageProcessing_EdgeDetection
        setEdgeDetectionImageProcessing(fragmentOutputColor.rgba, fragmentPixelCoordinates.xy);
        #else
        fragmentOutputColor.rgba = vec4(1.0f, 0.0f, 1.0f, 1.0f).rgba;
        #endif
    }
    else
    {
        fragmentOutputColor.rgba = vec4(1.0f, 0.0f, 1.0f, 1.0f).rgba;
    }
}

// SHADERTOY BUFFER A

const float CameraNearClippingPlane = 0.0001f;
const float CameraFarClippingPlane = 500.0f;
const vec3 CameraLookAtPosition = vec3(0.0f, 0.0f, 50.0f).xyz;

struct material { vec3 materialColor; float materialAmbient; float materialDiffuse; float materialSpecular; float materialShininess; };
struct surface { float surfaceDistance; material surfaceMaterial; };

mat3 getTransformAllInOneOrientation(const in vec3 transformTargetRotation)
{
    vec3 transformSineRotation = sin(radians(transformTargetRotation.xyz).xyz).xyz;
    vec3 transformCosineRotation = cos(radians(transformTargetRotation.xyz).xyz).xyz;
    
    mat3 transformPitchOrientation;
    transformPitchOrientation[0u].xyz = vec3(1.0f, 0.0f, 0.0f).xyz;
    transformPitchOrientation[1u].xyz = vec3(0.0f, transformCosineRotation.x, -transformSineRotation.x).xyz;
    transformPitchOrientation[2u].xyz = vec3(0.0f, transformSineRotation.x, transformCosineRotation.x).xyz;
    
    mat3 transformYawOrientation;
    transformYawOrientation[0u].xyz = vec3(transformCosineRotation.y, 0.0f, transformSineRotation.y).xyz;
    transformYawOrientation[1u].xyz = vec3(0.0f, 1.0f, 0.0f).xyz;
    transformYawOrientation[2u].xyz = vec3(-transformSineRotation.y, 0.0f, transformCosineRotation.y).xyz;
    
    mat3 transformRollOrientation;
    transformRollOrientation[0u].xyz = vec3(transformCosineRotation.z, -transformSineRotation.z, 0.0f).xyz;
    transformRollOrientation[1u].xyz = vec3(transformSineRotation.z, transformCosineRotation.z, 0.0f).xyz;
    transformRollOrientation[2u].xyz = vec3(0.0f, 0.0f, 1.0f).xyz;
    
    mat3 transformAllInOneOrientation = transformRollOrientation * transformYawOrientation * transformPitchOrientation;
    
    return transformAllInOneOrientation;
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
    float mixedSurfaceDistance;
    {
        float mixedSurfaceInterpolation = clamp(0.5f + 0.5f * (firstSurface.surfaceDistance - secondSurface.surfaceDistance) / mixedSurfaceSmoothness, 0.0f, 1.0f);
        
        mixedSurfaceDistance = mix(firstSurface.surfaceDistance, secondSurface.surfaceDistance, mixedSurfaceInterpolation) - mixedSurfaceSmoothness * mixedSurfaceInterpolation * (1.0f - mixedSurfaceInterpolation);
    }
    
    material mixedSurfaceMaterial;
    {
        float mixedSurfaceInterpolation = clamp((firstSurface.surfaceDistance - mixedSurfaceDistance) / (firstSurface.surfaceDistance + secondSurface.surfaceDistance - 2.0f * mixedSurfaceDistance), 0.0f, 1.0f);
        
        mixedSurfaceMaterial.materialColor.rgb = mix(firstSurface.surfaceMaterial.materialColor.rgb, secondSurface.surfaceMaterial.materialColor.rgb, mixedSurfaceInterpolation).rgb;
        mixedSurfaceMaterial.materialAmbient = mix(firstSurface.surfaceMaterial.materialAmbient, secondSurface.surfaceMaterial.materialAmbient, mixedSurfaceInterpolation);
        mixedSurfaceMaterial.materialDiffuse = mix(firstSurface.surfaceMaterial.materialDiffuse, secondSurface.surfaceMaterial.materialDiffuse, mixedSurfaceInterpolation);
        mixedSurfaceMaterial.materialSpecular = mix(firstSurface.surfaceMaterial.materialSpecular, secondSurface.surfaceMaterial.materialSpecular, mixedSurfaceInterpolation);
        mixedSurfaceMaterial.materialShininess = mix(firstSurface.surfaceMaterial.materialShininess, secondSurface.surfaceMaterial.materialShininess, mixedSurfaceInterpolation);
    }
    
    surface mixedSurface = surface(mixedSurfaceDistance, mixedSurfaceMaterial);
    
    return mixedSurface;
}

surface getSphereSurface(const in vec3 sceneRaypointPosition, const in vec3 sphereTransformPosition, const in vec3 sphereTransformRotation, const in float sphereTransformRadius, const in material sphereSurfaceMaterial)
{
    float sphereSurfaceDistance;
    {
        mat3 sphereTransformOrientation = getTransformAllInOneOrientation(sphereTransformRotation.xyz);
        
        vec3 sphereRaypointPosition = sphereTransformOrientation * (sceneRaypointPosition.xyz - sphereTransformPosition.xyz).xyz;
        
        sphereSurfaceDistance = length(sphereRaypointPosition.xyz) - abs(sphereTransformRadius);
    }
    
    surface sphereSurface = surface(sphereSurfaceDistance, sphereSurfaceMaterial);
    
    return sphereSurface;
}

surface getPrototypeSurface(const in vec3 sceneRaypointPosition, const in vec3 prototypeTransformPosition, const in vec3 prototypeTransformRotation, const in float prototypeTransformScale)
{
    vec3 prototypeRaypointPosition;
    {
        mat3 prototypeTransformOrientation = getTransformAllInOneOrientation(prototypeTransformRotation.xyz);
        
        prototypeRaypointPosition.xyz = prototypeTransformOrientation * (sceneRaypointPosition.xyz - prototypeTransformPosition.xyz).xyz;
    }
    
    surface upperCenterSurface;
    {
        vec3 upperCenterTransformPosition = prototypeTransformScale * vec3(0.0f, 0.5f * sqrt(3.0f) * 2.0f / 3.0f, 0.0f).xyz;
        vec3 upperCenterTransformRotation = vec3(0.0f, 0.0f, 0.0f).xyz;
        float upperCenterTransformRadius = 2.0f / 3.0f * prototypeTransformScale;
        
        material upperCenterSurfaceMaterial = material(vec3(1.0f, 0.0f, 0.0f).rgb, 0.075f, 0.75f, 1.0f, 0.45f);
        
        upperCenterSurface = getSphereSurface(prototypeRaypointPosition.xyz, upperCenterTransformPosition.xyz, upperCenterTransformRotation.xyz, upperCenterTransformRadius, upperCenterSurfaceMaterial);
    }
    
    surface lowerLeftSurface;
    {
        vec3 lowerLeftTransformPosition = prototypeTransformScale * vec3(-0.5f, -0.5f * sqrt(3.0f) / 3.0f, 0.0f).xyz;
        vec3 lowerLeftTransformRotation = vec3(0.0f, 0.0f, 0.0f).xyz;
        float lowerLeftTransformRadius = 2.0f / 3.0f * prototypeTransformScale;
        
        material lowerLeftSurfaceMaterial = material(vec3(0.0f, 1.0f, 0.0f).rgb, 0.075f, 0.75f, 1.0f, 0.45f);
        
        lowerLeftSurface = getSphereSurface(prototypeRaypointPosition.xyz, lowerLeftTransformPosition.xyz, lowerLeftTransformRotation.xyz, lowerLeftTransformRadius, lowerLeftSurfaceMaterial);
    }
    
    surface lowerRightSurface;
    {
        vec3 lowerRightTransformPosition = prototypeTransformScale * vec3(0.5f, -0.5f * sqrt(3.0f) / 3.0f, 0.0f).xyz;
        vec3 lowerRightTransformRotation = vec3(0.0f, 0.0f, 0.0f).xyz;
        float lowerRightTransformRadius = 2.0f / 3.0f * prototypeTransformScale;
        
        material lowerRightSurfaceMaterial = material(vec3(0.0f, 0.0f, 1.0f).rgb, 0.075f, 0.75f, 1.0f, 0.45f);
        
        lowerRightSurface = getSphereSurface(prototypeRaypointPosition.xyz, lowerRightTransformPosition.xyz, lowerRightTransformRotation.xyz, lowerRightTransformRadius, lowerRightSurfaceMaterial);
    }
    
    surface prototypeSurface;
    prototypeSurface = getMixedSurface(lowerLeftSurface, lowerRightSurface, 1.0f / 3.0f * prototypeTransformScale);
    prototypeSurface = getMixedSurface(prototypeSurface, upperCenterSurface, 1.0f / 3.0f * prototypeTransformScale);
    
    return prototypeSurface;
}

surface getSceneSurface(const in vec3 sampleRaypointPosition)
{
    surface prototypeSurface;
    {
        vec3 prototypeTransformPosition = CameraLookAtPosition.xyz;
        vec3 prototypeTransformRotation = vec3(90.0f * iTime, 45.0f * iTime, 90.0f * iTime).xyz;
        float prototypeTransformScale = 10.0f;
        
        prototypeSurface = getPrototypeSurface(sampleRaypointPosition.xyz, prototypeTransformPosition.xyz, prototypeTransformRotation.xyz, prototypeTransformScale);
    }
    
    surface sceneSurface;
    sceneSurface = prototypeSurface;
    
    return sceneSurface;
}

surface getRaymarchSurface(const in vec3 sampleRaypointPosition, const in vec3 sampleRaypointDirection)
{
    float raymarchSurfaceDistance = CameraNearClippingPlane;
    
    surface raymarchSurface;
    raymarchSurface.surfaceDistance = raymarchSurfaceDistance;
    
    const float RaymarchSurfaceIterator = 5000.0f;
    
    for (float raymarchSurfaceCounter = 0.0f; raymarchSurfaceCounter < RaymarchSurfaceIterator; raymarchSurfaceCounter++)
    {
        vec3 raymarchRaypointPosition = sampleRaypointPosition.xyz + raymarchSurfaceDistance * sampleRaypointDirection.xyz;
        
        raymarchSurface = getSceneSurface(raymarchRaypointPosition.xyz);
        
        if (raymarchSurface.surfaceDistance < CameraNearClippingPlane || raymarchSurfaceDistance > CameraFarClippingPlane)
        {
            break;
        }
        
        raymarchSurfaceDistance = raymarchSurfaceDistance + raymarchSurface.surfaceDistance;
    }
    
    raymarchSurface.surfaceDistance = raymarchSurfaceDistance;
    
    return raymarchSurface;
}

void setFragmentForegroundColor(inout vec3 fragmentOutputColor, const in vec3 cameraRaypointPosition, const in vec3 cameraRaypointDirection, const in surface raymarchSurface)
{
    vec3 normalRaypointPosition = cameraRaypointPosition.xyz + raymarchSurface.surfaceDistance * cameraRaypointDirection.xyz;
    vec3 normalRaypointDirection;
    normalRaypointDirection.x = getSceneSurface(normalRaypointPosition.xyz + vec2(0.0f, 0.0001f).yxx).surfaceDistance - getSceneSurface(normalRaypointPosition.xyz - vec2(0.0f, 0.0001f).yxx).surfaceDistance;
    normalRaypointDirection.y = getSceneSurface(normalRaypointPosition.xyz + vec2(0.0f, 0.0001f).xyx).surfaceDistance - getSceneSurface(normalRaypointPosition.xyz - vec2(0.0f, 0.0001f).xyx).surfaceDistance;
    normalRaypointDirection.z = getSceneSurface(normalRaypointPosition.xyz + vec2(0.0f, 0.0001f).xxy).surfaceDistance - getSceneSurface(normalRaypointPosition.xyz - vec2(0.0f, 0.0001f).xxy).surfaceDistance;
    normalRaypointDirection.xyz = normalize(normalRaypointDirection.xyz).xyz;
    
    vec3 lightRaypointPosition = vec3(-25.0f, 50.0f, 0.0f).xyz;
    vec3 lightRaypointDirection = normalize(lightRaypointPosition.xyz - normalRaypointPosition.xyz).xyz;
    
    vec3 reflectRaypointDirection = normalize(reflect(lightRaypointDirection.xyz, normalRaypointDirection.xyz).xyz).xyz;
    
    float raymarchSurfaceMaterialAmbient = raymarchSurface.surfaceMaterial.materialAmbient;
    raymarchSurfaceMaterialAmbient = clamp(raymarchSurfaceMaterialAmbient, 0.0f, 1.0f);
    
    float raymarchSurfaceMaterialDiffuse = raymarchSurface.surfaceMaterial.materialDiffuse;
    raymarchSurfaceMaterialDiffuse = raymarchSurfaceMaterialDiffuse * dot(lightRaypointDirection.xyz, normalRaypointDirection.xyz);
    raymarchSurfaceMaterialDiffuse = clamp(raymarchSurfaceMaterialDiffuse, 0.0f, 1.0f);
    
    const float SurfaceMaterialMinimumShininess = 16.0f;
    const float SurfaceMaterialMaximumShininess = 128.0f;
    float raymarchSurfaceMaterialShininess = mix(SurfaceMaterialMinimumShininess, SurfaceMaterialMaximumShininess, raymarchSurface.surfaceMaterial.materialShininess);
    float raymarchSurfaceMaterialSpecular = raymarchSurface.surfaceMaterial.materialSpecular;
    raymarchSurfaceMaterialSpecular = raymarchSurfaceMaterialSpecular * dot(cameraRaypointDirection.xyz, reflectRaypointDirection.xyz);
    raymarchSurfaceMaterialSpecular = clamp(raymarchSurfaceMaterialSpecular, 0.0f, 1.0f);
    raymarchSurfaceMaterialSpecular = pow(raymarchSurfaceMaterialSpecular, raymarchSurfaceMaterialShininess);
    
    vec3 raymarchSurfaceMaterialColor;
    raymarchSurfaceMaterialColor.rgb = raymarchSurfaceMaterialColor.rgb + raymarchSurfaceMaterialAmbient;
    raymarchSurfaceMaterialColor.rgb = raymarchSurfaceMaterialColor.rgb + raymarchSurfaceMaterialDiffuse;
    raymarchSurfaceMaterialColor.rgb = raymarchSurfaceMaterialColor.rgb + raymarchSurfaceMaterialSpecular;
    raymarchSurfaceMaterialColor.rgb = raymarchSurfaceMaterialColor.rgb * raymarchSurface.surfaceMaterial.materialColor.rgb;
    
    fragmentOutputColor.rgb = pow(raymarchSurfaceMaterialColor.rgb, vec3(1.0f / 2.2f, 1.0f / 2.2f, 1.0f / 2.2f).rgb).rgb;
}

void setFragmentBackgroundColor(inout vec3 fragmentOutputColor, const in vec2 fragmentInputCoordinates)
{
    const vec3 FragmentGridFirstColor = vec3(1.0f / 3.0f, 1.0f / 3.0f, 1.0f / 3.0f).rgb;
    const vec3 FragmentGridSecondColor = vec3(2.0f / 3.0f, 2.0f / 3.0f, 2.0f / 3.0f).rgb;
    const vec3 FragmentBorderColor = vec3(0.0f, 0.0f, 0.0f).rgb;
    
    const float FragmentGridDimension = 0.25f;
    const float FragmentBorderDimension = 0.075f;
    
    vec2 fragmentPixelCoordinates = (2.0f * fragmentInputCoordinates.xy - iResolution.xy).xy / min(iResolution.x, iResolution.y);
    
    if (iResolution.x < iResolution.y)
    {
        fragmentPixelCoordinates.xy = fragmentPixelCoordinates.xy + FragmentGridDimension * vec2(1.0f, 0.0f).xy;
    }
    else if (iResolution.x > iResolution.y)
    {
        fragmentPixelCoordinates.xy = fragmentPixelCoordinates.xy + FragmentGridDimension * vec2(0.0f, 1.0f).xy;
    }
    else
    {
        fragmentPixelCoordinates.xy = fragmentPixelCoordinates.xy + FragmentGridDimension * vec2(0.0f, 0.0f).xy;
    }
    
    vec2 fragmentGridCoordinates = floor(fragmentPixelCoordinates.xy / FragmentGridDimension).xy;
    float fragmentGridChecker = mod(fragmentGridCoordinates.x + fragmentGridCoordinates.y, 2.0f);
    
    if (fragmentGridChecker <= 0.0f)
    {
        fragmentOutputColor.rgb = FragmentGridFirstColor.rgb;
    }
    else if (fragmentGridChecker >= 1.0f)
    {
        fragmentOutputColor.rgb = FragmentGridSecondColor.rgb;
    }
    else
    {
        fragmentOutputColor.rgb = FragmentBorderColor.rgb;
    }
    
    vec2 fragmentBorderCoordinates = mod(fragmentPixelCoordinates.xy / FragmentGridDimension, 2.0f).xy;
    float fragmentBorderChecker = step(fragmentBorderCoordinates.x, FragmentBorderDimension) + step(fragmentBorderCoordinates.y, FragmentBorderDimension);
    
    if (fragmentBorderChecker >= 1.0f)
    {
        fragmentOutputColor.rgb = FragmentBorderColor.rgb;
    }
}

void mainImage(out vec4 fragmentOutputColor, in vec2 fragmentInputCoordinates)
{
    vec3 cameraRaypointPosition = vec3(25.0f, 25.0f, 25.0f).xyz;
    vec3 cameraRaypointDirection;
    {
        mat3 cameraTransformOrientation = getTransformLookAtOrientation(cameraRaypointPosition.xyz, CameraLookAtPosition.xyz);
        
        vec2 cameraViewportCoordinates = (2.0f * fragmentInputCoordinates.xy - iResolution.xy).xy / min(iResolution.x, iResolution.y);
        
        const float CameraMinimumFieldOfView = 10.0f;
        const float CameraMaximumFieldOfView = 170.0f;
        float cameraFocalLength = 1.0f / tan(0.5f * radians(clamp(30.0f, CameraMinimumFieldOfView, CameraMaximumFieldOfView)));
        
        cameraRaypointDirection.xyz = cameraTransformOrientation * normalize(vec3(cameraViewportCoordinates.xy, -cameraFocalLength).xyz).xyz;
    }
    
    surface raymarchSurface = getRaymarchSurface(cameraRaypointPosition.xyz, cameraRaypointDirection.xyz);
    
    if (raymarchSurface.surfaceDistance >= CameraNearClippingPlane && raymarchSurface.surfaceDistance <= CameraFarClippingPlane)
    {
        setFragmentForegroundColor(fragmentOutputColor.rgb, cameraRaypointPosition.xyz, cameraRaypointDirection.xyz, raymarchSurface);
    }
    else
    {
        setFragmentBackgroundColor(fragmentOutputColor.rgb, fragmentInputCoordinates.xy);
    }
}