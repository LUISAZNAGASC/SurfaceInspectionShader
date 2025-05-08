// LAST UPDATED DATE : 08/05/2025

// SHADERTOY IMAGE

const float NumericConstant_Zero = 0000000000.00000000000000000000f;
const float NumericConstant_One = 0000000001.00000000000000000000f;

#define PASS_THROUGH_IMAGE_PROCESSING 0u
#define GAUSSIAN_BLUR_IMAGE_PROCESSING 1u
#define EDGE_DETECTION_IMAGE_PROCESSING 2u

#define WINDOW_LEFT_SIDE_IMAGE_PROCESSING PASS_THROUGH_IMAGE_PROCESSING
#define WINDOW_RIGHT_SIDE_IMAGE_PROCESSING GAUSSIAN_BLUR_IMAGE_PROCESSING

float getFloatDataClampedFromZeroToOneThis(const in float floatDataUnclampedFromZeroToOneThis)
{
    float floatDataClampedFromZeroToOneThis = clamp(floatDataUnclampedFromZeroToOneThis, NumericConstant_Zero, NumericConstant_One);
    
    return floatDataClampedFromZeroToOneThis;
}

vec4 getColorDataDefinedThis(const in float colorDataUndefinedTintAmount)
{
    vec4 colorDataDefinedThis = vec4(colorDataUndefinedTintAmount, colorDataUndefinedTintAmount, colorDataUndefinedTintAmount, NumericConstant_One).rgba;
    colorDataDefinedThis.rgba = clamp(colorDataDefinedThis.rgba, NumericConstant_Zero, NumericConstant_One).rgba;
    
    return colorDataDefinedThis.rgba;
}

vec4 getColorDataDefinedThis(const in vec3 colorDataUndefinedThis)
{
    vec4 colorDataDefinedThis = vec4(colorDataUndefinedThis.r, colorDataUndefinedThis.g, colorDataUndefinedThis.b, NumericConstant_One).rgba;
    colorDataDefinedThis.rgba = clamp(colorDataDefinedThis.rgba, NumericConstant_Zero, NumericConstant_One).rgba;
    
    return colorDataDefinedThis.rgba;
}

vec4 getColorDataDefinedThis(const in vec4 colorDataUndefinedThis)
{
    vec4 colorDataDefinedThis = vec4(colorDataUndefinedThis.r, colorDataUndefinedThis.g, colorDataUndefinedThis.b, NumericConstant_One).rgba;
    colorDataDefinedThis.rgba = clamp(colorDataDefinedThis.rgba, NumericConstant_Zero, NumericConstant_One).rgba;
    
    return colorDataDefinedThis.rgba;
}

void SetInvalidOperationImageProcessing(inout vec4 fragmentOutputColor)
{
    fragmentOutputColor.rgba = getColorDataDefinedThis(NumericConstant_Zero).rgba;
}

void SetPassThroughImageProcessing(inout vec4 fragmentOutputColor, in vec2 fragmentTextureCoordinates)
{
    fragmentOutputColor.rgba = getColorDataDefinedThis(texture(iChannel0, fragmentTextureCoordinates.xy).rgba).rgba;
}

void SetGaussianBlurImageProcessing(inout vec4 fragmentOutputColor, in vec2 fragmentTextureCoordinates)
{
    const float fragmentTextureDownscaleFactor = 32.0f;
    vec2 fragmentTexturePixelSize = fragmentTextureDownscaleFactor * vec2(1.0f / iChannelResolution[0u].x, 1.0f / iChannelResolution[0u].y).xy;

    vec4 gaussianBlurColor;
    gaussianBlurColor.rgba += 0.0039062f * texture(iChannel0, vec2(-2.0f, -2.0f).xy * fragmentTexturePixelSize.xy + fragmentTextureCoordinates.xy).rgba;
    gaussianBlurColor.rgba += 0.0156250f * texture(iChannel0, vec2(-1.0f, -2.0f).xy * fragmentTexturePixelSize.xy + fragmentTextureCoordinates.xy).rgba;
    gaussianBlurColor.rgba += 0.0234375f * texture(iChannel0, vec2(+0.0f, -2.0f).xy * fragmentTexturePixelSize.xy + fragmentTextureCoordinates.xy).rgba;
    gaussianBlurColor.rgba += 0.0156250f * texture(iChannel0, vec2(+1.0f, -2.0f).xy * fragmentTexturePixelSize.xy + fragmentTextureCoordinates.xy).rgba;
    gaussianBlurColor.rgba += 0.0039062f * texture(iChannel0, vec2(+2.0f, -2.0f).xy * fragmentTexturePixelSize.xy + fragmentTextureCoordinates.xy).rgba;
    gaussianBlurColor.rgba += 0.0156250f * texture(iChannel0, vec2(-2.0f, -1.0f).xy * fragmentTexturePixelSize.xy + fragmentTextureCoordinates.xy).rgba;
    gaussianBlurColor.rgba += 0.0625000f * texture(iChannel0, vec2(-1.0f, -1.0f).xy * fragmentTexturePixelSize.xy + fragmentTextureCoordinates.xy).rgba;
    gaussianBlurColor.rgba += 0.0937500f * texture(iChannel0, vec2(+0.0f, -1.0f).xy * fragmentTexturePixelSize.xy + fragmentTextureCoordinates.xy).rgba;
    gaussianBlurColor.rgba += 0.0625000f * texture(iChannel0, vec2(+1.0f, -1.0f).xy * fragmentTexturePixelSize.xy + fragmentTextureCoordinates.xy).rgba;
    gaussianBlurColor.rgba += 0.0156250f * texture(iChannel0, vec2(+2.0f, -1.0f).xy * fragmentTexturePixelSize.xy + fragmentTextureCoordinates.xy).rgba;
    gaussianBlurColor.rgba += 0.0234375f * texture(iChannel0, vec2(-2.0f, +0.0f).xy * fragmentTexturePixelSize.xy + fragmentTextureCoordinates.xy).rgba;
    gaussianBlurColor.rgba += 0.0937500f * texture(iChannel0, vec2(-1.0f, +0.0f).xy * fragmentTexturePixelSize.xy + fragmentTextureCoordinates.xy).rgba;
    gaussianBlurColor.rgba += 0.1406250f * texture(iChannel0, vec2(+0.0f, +0.0f).xy * fragmentTexturePixelSize.xy + fragmentTextureCoordinates.xy).rgba;
    gaussianBlurColor.rgba += 0.0937500f * texture(iChannel0, vec2(+1.0f, +0.0f).xy * fragmentTexturePixelSize.xy + fragmentTextureCoordinates.xy).rgba;
    gaussianBlurColor.rgba += 0.0234375f * texture(iChannel0, vec2(+2.0f, +0.0f).xy * fragmentTexturePixelSize.xy + fragmentTextureCoordinates.xy).rgba;
    gaussianBlurColor.rgba += 0.0156250f * texture(iChannel0, vec2(-2.0f, +1.0f).xy * fragmentTexturePixelSize.xy + fragmentTextureCoordinates.xy).rgba;
    gaussianBlurColor.rgba += 0.0625000f * texture(iChannel0, vec2(-1.0f, +1.0f).xy * fragmentTexturePixelSize.xy + fragmentTextureCoordinates.xy).rgba;
    gaussianBlurColor.rgba += 0.0937500f * texture(iChannel0, vec2(+0.0f, +1.0f).xy * fragmentTexturePixelSize.xy + fragmentTextureCoordinates.xy).rgba;
    gaussianBlurColor.rgba += 0.0625000f * texture(iChannel0, vec2(+1.0f, +1.0f).xy * fragmentTexturePixelSize.xy + fragmentTextureCoordinates.xy).rgba;
    gaussianBlurColor.rgba += 0.0156250f * texture(iChannel0, vec2(+2.0f, +1.0f).xy * fragmentTexturePixelSize.xy + fragmentTextureCoordinates.xy).rgba;
    gaussianBlurColor.rgba += 0.0039062f * texture(iChannel0, vec2(-2.0f, +2.0f).xy * fragmentTexturePixelSize.xy + fragmentTextureCoordinates.xy).rgba;
    gaussianBlurColor.rgba += 0.0156250f * texture(iChannel0, vec2(-1.0f, +2.0f).xy * fragmentTexturePixelSize.xy + fragmentTextureCoordinates.xy).rgba;
    gaussianBlurColor.rgba += 0.0234375f * texture(iChannel0, vec2(+0.0f, +2.0f).xy * fragmentTexturePixelSize.xy + fragmentTextureCoordinates.xy).rgba;
    gaussianBlurColor.rgba += 0.0156250f * texture(iChannel0, vec2(+1.0f, +2.0f).xy * fragmentTexturePixelSize.xy + fragmentTextureCoordinates.xy).rgba;
    gaussianBlurColor.rgba += 0.0039062f * texture(iChannel0, vec2(+2.0f, +2.0f).xy * fragmentTexturePixelSize.xy + fragmentTextureCoordinates.xy).rgba;

    fragmentOutputColor.rgba = getColorDataDefinedThis(gaussianBlurColor.rgba).rgba;
}

void SetEdgeDetectionImageProcessing(inout vec4 fragmentOutputColor, in vec2 fragmentTextureCoordinates)
{
    vec2 fragmentTexturePixelSize = vec2(1.0f / iChannelResolution[0u].x, 1.0f / iChannelResolution[0u].y).xy;
    
    vec4 edgeDetectionXGradient;
    edgeDetectionXGradient.rgba += -1.0f * texture(iChannel0, vec2(-1.0f, -1.0f).xy * fragmentTexturePixelSize.xy + fragmentTextureCoordinates.xy).rgba;
    edgeDetectionXGradient.rgba += +0.0f * texture(iChannel0, vec2(+0.0f, -1.0f).xy * fragmentTexturePixelSize.xy + fragmentTextureCoordinates.xy).rgba;
    edgeDetectionXGradient.rgba += +1.0f * texture(iChannel0, vec2(+1.0f, -1.0f).xy * fragmentTexturePixelSize.xy + fragmentTextureCoordinates.xy).rgba;
    edgeDetectionXGradient.rgba += -2.0f * texture(iChannel0, vec2(-1.0f, +0.0f).xy * fragmentTexturePixelSize.xy + fragmentTextureCoordinates.xy).rgba;
    edgeDetectionXGradient.rgba += +0.0f * texture(iChannel0, vec2(+0.0f, +0.0f).xy * fragmentTexturePixelSize.xy + fragmentTextureCoordinates.xy).rgba;
    edgeDetectionXGradient.rgba += +2.0f * texture(iChannel0, vec2(+1.0f, +0.0f).xy * fragmentTexturePixelSize.xy + fragmentTextureCoordinates.xy).rgba;
    edgeDetectionXGradient.rgba += -1.0f * texture(iChannel0, vec2(-1.0f, +1.0f).xy * fragmentTexturePixelSize.xy + fragmentTextureCoordinates.xy).rgba;
    edgeDetectionXGradient.rgba += +0.0f * texture(iChannel0, vec2(+0.0f, +1.0f).xy * fragmentTexturePixelSize.xy + fragmentTextureCoordinates.xy).rgba;
    edgeDetectionXGradient.rgba += +1.0f * texture(iChannel0, vec2(+1.0f, +1.0f).xy * fragmentTexturePixelSize.xy + fragmentTextureCoordinates.xy).rgba;
    
    float edgeDetectionXIntensity = length(edgeDetectionXGradient.rgba);
    
    vec4 edgeDetectionYGradient;
    edgeDetectionYGradient.rgba += +1.0f * texture(iChannel0, vec2(-1.0f, -1.0f).xy * fragmentTexturePixelSize.xy + fragmentTextureCoordinates.xy).rgba;
    edgeDetectionYGradient.rgba += +2.0f * texture(iChannel0, vec2(+0.0f, -1.0f).xy * fragmentTexturePixelSize.xy + fragmentTextureCoordinates.xy).rgba;
    edgeDetectionYGradient.rgba += +1.0f * texture(iChannel0, vec2(+1.0f, -1.0f).xy * fragmentTexturePixelSize.xy + fragmentTextureCoordinates.xy).rgba;
    edgeDetectionYGradient.rgba += +0.0f * texture(iChannel0, vec2(-1.0f, +0.0f).xy * fragmentTexturePixelSize.xy + fragmentTextureCoordinates.xy).rgba;
    edgeDetectionYGradient.rgba += +0.0f * texture(iChannel0, vec2(+0.0f, +0.0f).xy * fragmentTexturePixelSize.xy + fragmentTextureCoordinates.xy).rgba;
    edgeDetectionYGradient.rgba += +0.0f * texture(iChannel0, vec2(+1.0f, +0.0f).xy * fragmentTexturePixelSize.xy + fragmentTextureCoordinates.xy).rgba;
    edgeDetectionYGradient.rgba += -1.0f * texture(iChannel0, vec2(-1.0f, +1.0f).xy * fragmentTexturePixelSize.xy + fragmentTextureCoordinates.xy).rgba;
    edgeDetectionYGradient.rgba += -2.0f * texture(iChannel0, vec2(+0.0f, +1.0f).xy * fragmentTexturePixelSize.xy + fragmentTextureCoordinates.xy).rgba;
    edgeDetectionYGradient.rgba += -1.0f * texture(iChannel0, vec2(+1.0f, +1.0f).xy * fragmentTexturePixelSize.xy + fragmentTextureCoordinates.xy).rgba;
    
    float edgeDetectionYIntensity = length(edgeDetectionYGradient.rgba);
    
    float edgeDetectionFullIntensity = sqrt(edgeDetectionXIntensity * edgeDetectionXIntensity + edgeDetectionYIntensity * edgeDetectionYIntensity);
    
    fragmentOutputColor.rgba = getColorDataDefinedThis(edgeDetectionFullIntensity).rgba;
}

void mainImage(out vec4 fragmentOutputColor, in vec2 fragmentInputCoordinates)
{
    vec2 fragmentTextureCoordinates = fragmentInputCoordinates.xy / iChannelResolution[0u].xy;
    
    float mouseSliderHorizontal = iMouse.z >= NumericConstant_One ? iMouse.x / iChannelResolution[0u].x : NumericConstant_One / 2.0f;
    mouseSliderHorizontal = getFloatDataClampedFromZeroToOneThis(mouseSliderHorizontal);
    
    if (fragmentTextureCoordinates.x <= mouseSliderHorizontal)
    {
        #if WINDOW_LEFT_SIDE_IMAGE_PROCESSING == PASS_THROUGH_IMAGE_PROCESSING
        SetPassThroughImageProcessing(fragmentOutputColor.rgba, fragmentTextureCoordinates.xy);
        #elif WINDOW_LEFT_SIDE_IMAGE_PROCESSING == GAUSSIAN_BLUR_IMAGE_PROCESSING
        SetGaussianBlurImageProcessing(fragmentOutputColor.rgba, fragmentTextureCoordinates.xy);
        #elif WINDOW_LEFT_SIDE_IMAGE_PROCESSING == EDGE_DETECTION_IMAGE_PROCESSING
        SetEdgeDetectionImageProcessing(fragmentOutputColor.rgba, fragmentTextureCoordinates.xy);
        #else
        SetInvalidOperationImageProcessing(fragmentOutputColor.rgba);
        #endif
    }
    else if (fragmentTextureCoordinates.x >= mouseSliderHorizontal)
    {
        #if WINDOW_RIGHT_SIDE_IMAGE_PROCESSING == PASS_THROUGH_IMAGE_PROCESSING
        SetPassThroughImageProcessing(fragmentOutputColor.rgba, fragmentTextureCoordinates.xy);
        #elif WINDOW_RIGHT_SIDE_IMAGE_PROCESSING == GAUSSIAN_BLUR_IMAGE_PROCESSING
        SetGaussianBlurImageProcessing(fragmentOutputColor.rgba, fragmentTextureCoordinates.xy);
        #elif WINDOW_RIGHT_SIDE_IMAGE_PROCESSING == EDGE_DETECTION_IMAGE_PROCESSING
        SetEdgeDetectionImageProcessing(fragmentOutputColor.rgba, fragmentTextureCoordinates.xy);
        #else
        SetInvalidOperationImageProcessing(fragmentOutputColor.rgba);
        #endif
    }
    else
    {
        SetInvalidOperationImageProcessing(fragmentOutputColor.rgba);
    }
}

// SHADERTOY BUFFER A

const float NumericConstant_Zero = 0000000000.00000000000000000000f;
const float NumericConstant_One = 0000000001.00000000000000000000f;
const float NumericConstant_Epsilon = 0000000000.00010000000000000000f;
const float NumericConstant_Pi = 0000000003.14159265358979323846f;
const float NumericConstant_Gamma = 0000000000.45454545454545454545f;

const float CameraConstant_FarClippingPlane = 0000000500.00000000000000000000f;

const vec3 Scene_PointOfViewPosition = vec3(-6.0f, -6.0f, 24.0f).xyz;

struct raypointData
{
    vec4 raypointDataPosition;
    vec4 raypointDataDirection;
};

struct transformData
{
    vec3 transformDataPosition;
    vec3 transformDataRotation;
    float transformDataDimension;
};

struct materialData
{
    vec4 materialDataGeneralColor;
    float materialDataAmbientAmount;
    float materialDataDiffuseAmount;
    float materialDataSpecularAmount;
    float materialDataSpecularShininess;
};

struct surfaceData
{
    float surfaceDataSignedDistance;
    materialData surfaceDataMaterialData;
};

float getFloatDataClampedFromZeroToOneThis(const in float floatDataUnclampedFromZeroToOneThis)
{
    float floatDataClampedFromZeroToOneThis = clamp(floatDataUnclampedFromZeroToOneThis, NumericConstant_Zero, NumericConstant_One);
    
    return floatDataClampedFromZeroToOneThis;
}

vec4 getRaypointDataDefinedPosition(const in vec3 raypointDataUndefinedPosition)
{
    vec4 raypointDataDefinedPosition = vec4(raypointDataUndefinedPosition.x, raypointDataUndefinedPosition.y, raypointDataUndefinedPosition.z, NumericConstant_One).xyzw;
    
    return raypointDataDefinedPosition.xyzw;
}

vec4 getRaypointDataDefinedPosition(const in vec4 raypointDataUndefinedPosition)
{
    vec4 raypointDataDefinedPosition = vec4(raypointDataUndefinedPosition.x, raypointDataUndefinedPosition.y, raypointDataUndefinedPosition.z, NumericConstant_One).xyzw;
    
    return raypointDataDefinedPosition.xyzw;
}

vec4 getRaypointDataDefinedDirection(const in vec3 raypointDataUndefinedDirection)
{
    vec4 raypointDataDefinedDirection = vec4(raypointDataUndefinedDirection.x, raypointDataUndefinedDirection.y, raypointDataUndefinedDirection.z, NumericConstant_Zero).xyzw;
    raypointDataDefinedDirection.xyzw = normalize(raypointDataDefinedDirection.xyzw).xyzw;
    
    return raypointDataDefinedDirection.xyzw;
}

vec4 getRaypointDataDefinedDirection(const in vec4 raypointDataUndefinedDirection)
{
    vec4 raypointDataDefinedDirection = vec4(raypointDataUndefinedDirection.x, raypointDataUndefinedDirection.y, raypointDataUndefinedDirection.z, NumericConstant_Zero).xyzw;
    raypointDataDefinedDirection.xyzw = normalize(raypointDataDefinedDirection.xyzw).xyzw;
    
    return raypointDataDefinedDirection.xyzw;
}

mat4 getTransformDataIdentityTransformation()
{
    mat4 transformDataIdentityTransformation;
    transformDataIdentityTransformation[0u].xyzw = vec4(NumericConstant_One, NumericConstant_Zero, NumericConstant_Zero, NumericConstant_Zero).xyzw;
    transformDataIdentityTransformation[1u].xyzw = vec4(NumericConstant_Zero, NumericConstant_One, NumericConstant_Zero, NumericConstant_Zero).xyzw;
    transformDataIdentityTransformation[2u].xyzw = vec4(NumericConstant_Zero, NumericConstant_Zero, NumericConstant_One, NumericConstant_Zero).xyzw;
    transformDataIdentityTransformation[3u].xyzw = vec4(NumericConstant_Zero, NumericConstant_Zero, NumericConstant_Zero, NumericConstant_One).xyzw;
    
    return transformDataIdentityTransformation;
}

mat4 getTransformDataLocalTranslation(const in vec3 transformDataTargetPosition)
{
    mat4 transformDataLocalTranslation;
    transformDataLocalTranslation[0u].xyzw = vec4(NumericConstant_One, NumericConstant_Zero, NumericConstant_Zero, NumericConstant_Zero).xyzw;
    transformDataLocalTranslation[1u].xyzw = vec4(NumericConstant_Zero, NumericConstant_One, NumericConstant_Zero, NumericConstant_Zero).xyzw;
    transformDataLocalTranslation[2u].xyzw = vec4(NumericConstant_Zero, NumericConstant_Zero, NumericConstant_One, NumericConstant_Zero).xyzw;
    transformDataLocalTranslation[3u].xyzw = vec4(transformDataTargetPosition.x, transformDataTargetPosition.y, transformDataTargetPosition.z, NumericConstant_One).xyzw;
    
    return transformDataLocalTranslation;
}

mat4 getTransformDataLocalOrientation(const in vec3 transformDataTargetRotation)
{
    vec3 transformDataSineRotation = sin(radians(transformDataTargetRotation.xyz).xyz).xyz;
    vec3 transformDataCosineRotation = cos(radians(transformDataTargetRotation.xyz).xyz).xyz;
    
    mat4 transformDataLocalPitchOrientation;
    transformDataLocalPitchOrientation[0u].xyzw = vec4(NumericConstant_One, NumericConstant_Zero, NumericConstant_Zero, NumericConstant_Zero).xyzw;
    transformDataLocalPitchOrientation[1u].xyzw = vec4(NumericConstant_Zero, transformDataCosineRotation.x, -transformDataSineRotation.x, NumericConstant_Zero).xyzw;
    transformDataLocalPitchOrientation[2u].xyzw = vec4(NumericConstant_Zero, transformDataSineRotation.x, transformDataCosineRotation.x, NumericConstant_Zero).xyzw;
    transformDataLocalPitchOrientation[3u].xyzw = vec4(NumericConstant_Zero, NumericConstant_Zero, NumericConstant_Zero, NumericConstant_One).xyzw;
    
    mat4 transformDataLocalYawOrientation;
    transformDataLocalYawOrientation[0u].xyzw = vec4(transformDataCosineRotation.y, NumericConstant_Zero, transformDataSineRotation.y, NumericConstant_Zero).xyzw;
    transformDataLocalYawOrientation[1u].xyzw = vec4(NumericConstant_Zero, NumericConstant_One, NumericConstant_Zero, NumericConstant_Zero).xyzw;
    transformDataLocalYawOrientation[2u].xyzw = vec4(-transformDataSineRotation.y, NumericConstant_Zero, transformDataCosineRotation.y, NumericConstant_Zero).xyzw;
    transformDataLocalYawOrientation[3u].xyzw = vec4(NumericConstant_Zero, NumericConstant_Zero, NumericConstant_Zero, NumericConstant_One).xyzw;
    
    mat4 transformDataLocalRollOrientation;
    transformDataLocalRollOrientation[0u].xyzw = vec4(transformDataCosineRotation.z, -transformDataSineRotation.z, NumericConstant_Zero, NumericConstant_Zero).xyzw;
    transformDataLocalRollOrientation[1u].xyzw = vec4(transformDataSineRotation.z, transformDataCosineRotation.z, NumericConstant_Zero, NumericConstant_Zero).xyzw;
    transformDataLocalRollOrientation[2u].xyzw = vec4(NumericConstant_Zero, NumericConstant_Zero, NumericConstant_One, NumericConstant_Zero).xyzw;
    transformDataLocalRollOrientation[3u].xyzw = vec4(NumericConstant_Zero, NumericConstant_Zero, NumericConstant_Zero, NumericConstant_One).xyzw;
    
    mat4 transformDataLocalOrientation = transformDataLocalPitchOrientation * transformDataLocalYawOrientation * transformDataLocalRollOrientation;
    
    return transformDataLocalOrientation;
}

mat4 getTransformDataLookAtOrientation(const in vec3 transformDataOriginPosition, const in vec3 transformDataTargetPosition)
{
    const vec3 RaypointDataGlobalUpwardDirection = normalize(vec3(NumericConstant_Zero, NumericConstant_One, NumericConstant_Zero).xyz).xyz;
    
    vec3 raypointDataLocalForwardDirection = normalize(transformDataTargetPosition.xyz - transformDataOriginPosition.xyz).xyz;
    vec3 raypointDataLocalRightwardDirection = normalize(cross(RaypointDataGlobalUpwardDirection.xyz, raypointDataLocalForwardDirection.xyz).xyz).xyz;
    vec3 raypointDataLocalUpwardDirection = normalize(cross(raypointDataLocalForwardDirection.xyz, raypointDataLocalRightwardDirection.xyz).xyz).xyz;
    
    mat4 transformDataLookAtOrientation;
    transformDataLookAtOrientation[0u].xyzw = -getRaypointDataDefinedDirection(raypointDataLocalRightwardDirection.xyz).xyzw;
    transformDataLookAtOrientation[1u].xyzw = getRaypointDataDefinedDirection(raypointDataLocalUpwardDirection.xyz).xyzw;
    transformDataLookAtOrientation[2u].xyzw = -getRaypointDataDefinedDirection(raypointDataLocalForwardDirection.xyz).xyzw;
    transformDataLookAtOrientation[3u].xyzw = vec4(NumericConstant_Zero, NumericConstant_Zero, NumericConstant_Zero, NumericConstant_One).xyzw;
    
    return transformDataLookAtOrientation;
}

vec4 getColorDataDefinedThis(const in float colorDataUndefinedTintAmount)
{
    vec4 colorDataDefinedThis = vec4(colorDataUndefinedTintAmount, colorDataUndefinedTintAmount, colorDataUndefinedTintAmount, NumericConstant_One).rgba;
    colorDataDefinedThis.rgba = clamp(colorDataDefinedThis.rgba, NumericConstant_Zero, NumericConstant_One).rgba;
    
    return colorDataDefinedThis.rgba;
}

vec4 getColorDataDefinedThis(const in vec3 colorDataUndefinedThis)
{
    vec4 colorDataDefinedThis = vec4(colorDataUndefinedThis.r, colorDataUndefinedThis.g, colorDataUndefinedThis.b, NumericConstant_One).rgba;
    colorDataDefinedThis.rgba = clamp(colorDataDefinedThis.rgba, NumericConstant_Zero, NumericConstant_One).rgba;
    
    return colorDataDefinedThis.rgba;
}

vec4 getColorDataDefinedThis(const in vec4 colorDataUndefinedThis)
{
    vec4 colorDataDefinedThis = vec4(colorDataUndefinedThis.r, colorDataUndefinedThis.g, colorDataUndefinedThis.b, NumericConstant_One).rgba;
    colorDataDefinedThis.rgba = clamp(colorDataDefinedThis.rgba, NumericConstant_Zero, NumericConstant_One).rgba;
    
    return colorDataDefinedThis.rgba;
}

materialData getMaterialDataDefinedThis(const in materialData materialDataUndefinedThis)
{
    materialData materialDataDefinedThis;
    materialDataDefinedThis.materialDataGeneralColor.rgba = getColorDataDefinedThis(materialDataUndefinedThis.materialDataGeneralColor.rgba).rgba;
    materialDataDefinedThis.materialDataAmbientAmount = getFloatDataClampedFromZeroToOneThis(materialDataUndefinedThis.materialDataAmbientAmount);
    materialDataDefinedThis.materialDataDiffuseAmount = getFloatDataClampedFromZeroToOneThis(materialDataUndefinedThis.materialDataDiffuseAmount);
    materialDataDefinedThis.materialDataSpecularAmount = getFloatDataClampedFromZeroToOneThis(materialDataUndefinedThis.materialDataSpecularAmount);
    materialDataDefinedThis.materialDataSpecularShininess = getFloatDataClampedFromZeroToOneThis(materialDataUndefinedThis.materialDataSpecularShininess);
    
    return materialDataDefinedThis;
}

materialData getMixedMaterialData(const in materialData firstMaterialData, const in materialData secondMaterialData, const in float mixedMaterialMixFactor)
{
    materialData mixedMaterialData;
    
    if (mixedMaterialMixFactor <= NumericConstant_Zero)
    {
        mixedMaterialData = getMaterialDataDefinedThis(firstMaterialData);
    }
    else if (mixedMaterialMixFactor >= NumericConstant_One)
    {
        mixedMaterialData = getMaterialDataDefinedThis(secondMaterialData);
    }
    else
    {
        mixedMaterialData.materialDataGeneralColor.rgba = mix(firstMaterialData.materialDataGeneralColor.rgba, secondMaterialData.materialDataGeneralColor.rgba, mixedMaterialMixFactor).rgba;
        mixedMaterialData.materialDataAmbientAmount = mix(firstMaterialData.materialDataAmbientAmount, secondMaterialData.materialDataAmbientAmount, mixedMaterialMixFactor);
        mixedMaterialData.materialDataDiffuseAmount = mix(firstMaterialData.materialDataDiffuseAmount, secondMaterialData.materialDataDiffuseAmount, mixedMaterialMixFactor);
        mixedMaterialData.materialDataSpecularAmount = mix(firstMaterialData.materialDataSpecularAmount, secondMaterialData.materialDataSpecularAmount, mixedMaterialMixFactor);
        mixedMaterialData.materialDataSpecularShininess = mix(firstMaterialData.materialDataSpecularShininess, secondMaterialData.materialDataSpecularShininess, mixedMaterialMixFactor);
    }
    
    return mixedMaterialData;
}

surfaceData getCombinedSurfaceData(const in surfaceData firstSurfaceData, const in surfaceData secondSurfaceData, const in float combinedSurfaceBlendFactor)
{
    float combinedSurfaceDataSignedDistance;
    {
        float combinedSurfaceDifferenceFactor = firstSurfaceData.surfaceDataSignedDistance - secondSurfaceData.surfaceDataSignedDistance;
        combinedSurfaceDifferenceFactor = getFloatDataClampedFromZeroToOneThis(0.5f + 0.5f * combinedSurfaceDifferenceFactor / combinedSurfaceBlendFactor);
        
        combinedSurfaceDataSignedDistance = mix(firstSurfaceData.surfaceDataSignedDistance, secondSurfaceData.surfaceDataSignedDistance, combinedSurfaceDifferenceFactor);
        combinedSurfaceDataSignedDistance -= combinedSurfaceBlendFactor * combinedSurfaceDifferenceFactor * (1.0f - combinedSurfaceDifferenceFactor);
    }
    
    materialData combinedSurfaceDataMaterialData;
    {
        float combinedSurfaceMixFactor;
        {
            float firstSurfaceDataSignedDistanceDifference = firstSurfaceData.surfaceDataSignedDistance - combinedSurfaceDataSignedDistance;
            float secondSurfaceDataSignedDistanceDifference = secondSurfaceData.surfaceDataSignedDistance - combinedSurfaceDataSignedDistance;
            
            combinedSurfaceMixFactor = firstSurfaceDataSignedDistanceDifference / (firstSurfaceDataSignedDistanceDifference + secondSurfaceDataSignedDistanceDifference);
        }
        
        combinedSurfaceDataMaterialData = getMixedMaterialData(firstSurfaceData.surfaceDataMaterialData, secondSurfaceData.surfaceDataMaterialData, combinedSurfaceMixFactor);
    }
    
    surfaceData combinedSurfaceData;
    combinedSurfaceData.surfaceDataSignedDistance = combinedSurfaceDataSignedDistance;
    combinedSurfaceData.surfaceDataMaterialData = combinedSurfaceDataMaterialData;
    
    return combinedSurfaceData;
}

surfaceData getSphereSurfaceData(const in vec4 sphereRaypointDataPosition, const in transformData sphereTransformData, const in materialData sphereMaterialData)
{
    float sphereSurfaceDataSignedDistance;
    {
        mat4 sphereTransformDataFullTransformation = getTransformDataIdentityTransformation();
        sphereTransformDataFullTransformation *= getTransformDataLocalTranslation(sphereTransformData.transformDataPosition.xyz);
        sphereTransformDataFullTransformation *= getTransformDataLocalOrientation(sphereTransformData.transformDataRotation.xyz);
        sphereTransformDataFullTransformation = inverse(sphereTransformDataFullTransformation);
        
        vec4 sphereRaypointDataFullPosition = getRaypointDataDefinedPosition(sphereRaypointDataPosition.xyzw).xyzw;
        sphereRaypointDataFullPosition.xyzw = sphereTransformDataFullTransformation * sphereRaypointDataFullPosition.xyzw;
        
        sphereSurfaceDataSignedDistance = length(sphereRaypointDataFullPosition.xyzw) - abs(sphereTransformData.transformDataDimension);
    }
    
    materialData sphereSurfaceDataMaterialData = getMaterialDataDefinedThis(sphereMaterialData);
    
    surfaceData sphereSurfaceData;
    sphereSurfaceData.surfaceDataSignedDistance = sphereSurfaceDataSignedDistance;
    sphereSurfaceData.surfaceDataMaterialData = sphereSurfaceDataMaterialData;
    
    return sphereSurfaceData;
}

surfaceData getSceneSurfaceData(const in vec4 sceneRaypointDataPosition)
{
    vec4 sceneRaypointDataFullPosition = getRaypointDataDefinedPosition(sceneRaypointDataPosition.xyzw).xyzw;
    
    surfaceData dualSphereSurfaceData;
    {
        const float DualSphereTransformScale = 6.0f;
        
        vec4 dualSphereRaypointDataFullPosition;
        {
            vec3 dualSphereTransformDataPosition = vec3(0.0f, 0.5f * DualSphereTransformScale * sin(NumericConstant_Pi * iTime), 0.0f).xyz;
            
            mat4 dualSphereTransformDataFullTransformation = getTransformDataIdentityTransformation();
            dualSphereTransformDataFullTransformation *= getTransformDataLocalTranslation(Scene_PointOfViewPosition.xyz + dualSphereTransformDataPosition.xyz);
            dualSphereTransformDataFullTransformation *= getTransformDataLocalOrientation(vec3(0.0f, 45.0f * iTime, 0.0f).xyz);
            dualSphereTransformDataFullTransformation = inverse(dualSphereTransformDataFullTransformation);
            
            dualSphereRaypointDataFullPosition.xyzw = getRaypointDataDefinedPosition(sceneRaypointDataFullPosition.xyzw).xyzw;
            dualSphereRaypointDataFullPosition.xyzw = dualSphereTransformDataFullTransformation * dualSphereRaypointDataFullPosition.xyzw;
        }
        
        materialData dualSphereMaterialData;
        dualSphereMaterialData.materialDataGeneralColor.rgba = getColorDataDefinedThis(vec3(1.0f, 0.0f, 1.0f).rgb).rgba;
        dualSphereMaterialData.materialDataAmbientAmount = 0.1f;
        dualSphereMaterialData.materialDataDiffuseAmount = 0.6f;
        dualSphereMaterialData.materialDataSpecularAmount = 1.0f;
        dualSphereMaterialData.materialDataSpecularShininess = 0.75f;
        dualSphereMaterialData = getMaterialDataDefinedThis(dualSphereMaterialData);
        
        surfaceData leftSphereSurfaceData;
        {
            transformData leftSphereTransformData;
            leftSphereTransformData.transformDataPosition.xyz = vec3(-2.0f / 3.0f * DualSphereTransformScale, 0.0f, 0.0f).xyz;
            leftSphereTransformData.transformDataRotation.xyz = vec3(0.0f, 0.0f, 0.0f).xyz;
            leftSphereTransformData.transformDataDimension = DualSphereTransformScale;
            
            leftSphereSurfaceData = getSphereSurfaceData(dualSphereRaypointDataFullPosition.xyzw, leftSphereTransformData, dualSphereMaterialData);
        }
        
        surfaceData rightSphereSurfaceData;
        {
            transformData rightSphereTransformData;
            rightSphereTransformData.transformDataPosition.xyz = vec3(2.0f / 3.0f * DualSphereTransformScale, 0.0f, 0.0f).xyz;
            rightSphereTransformData.transformDataRotation.xyz = vec3(0.0f, 0.0f, 0.0f).xyz;
            rightSphereTransformData.transformDataDimension = DualSphereTransformScale;
            
            rightSphereSurfaceData = getSphereSurfaceData(dualSphereRaypointDataFullPosition.xyzw, rightSphereTransformData, dualSphereMaterialData);
        }
        
        dualSphereSurfaceData = getCombinedSurfaceData(leftSphereSurfaceData, rightSphereSurfaceData, 1.0f / 3.0f * DualSphereTransformScale);
    }
    
    surfaceData sceneSurfaceData = dualSphereSurfaceData;
    
    return sceneSurfaceData;
}

raypointData getSceneCameraRaypointData(const in vec3 sceneCameraTransformDataPosition, const in vec3 sceneLookAtTransformDataPosition, const in vec2 sceneCameraViewportCoordinates, const in float sceneCameraFieldOfView)
{
    vec4 sceneCameraRaypointDataPosition = getRaypointDataDefinedPosition(sceneCameraTransformDataPosition.xyz).xyzw;
    
    vec4 sceneCameraRaypointDataDirection;
    {
        float sceneCameraFocalLength = 1.0f / tan(0.5f * radians(max(sceneCameraFieldOfView, NumericConstant_Epsilon)));
        
        mat4 sceneCameraTransformDataFullTransformation = getTransformDataIdentityTransformation();
        sceneCameraTransformDataFullTransformation *= getTransformDataLookAtOrientation(sceneCameraTransformDataPosition.xyz, sceneLookAtTransformDataPosition.xyz);
        
        sceneCameraRaypointDataDirection.xy = sceneCameraViewportCoordinates.xy;
        sceneCameraRaypointDataDirection.z = -sceneCameraFocalLength;
        sceneCameraRaypointDataDirection.w = NumericConstant_Zero;
        sceneCameraRaypointDataDirection.xyzw = getRaypointDataDefinedDirection(sceneCameraRaypointDataDirection.xyzw).xyzw;
        sceneCameraRaypointDataDirection.xyzw = sceneCameraTransformDataFullTransformation * sceneCameraRaypointDataDirection.xyzw;
    }
    
    raypointData sceneCameraRaypointData;
    sceneCameraRaypointData.raypointDataPosition.xyzw = sceneCameraRaypointDataPosition.xyzw;
    sceneCameraRaypointData.raypointDataDirection.xyzw = sceneCameraRaypointDataDirection.xyzw;
    
    return sceneCameraRaypointData;
}

surfaceData getSceneRaymarchSurfaceData(const in raypointData sceneCameraRaypointData)
{
    float sceneRaymarchEpsilon = NumericConstant_Epsilon;
    
    float sceneRaymarchTraveledDistance;
    
    surfaceData sceneRaymarchSurfaceData;
    sceneRaymarchSurfaceData.surfaceDataSignedDistance = sceneRaymarchTraveledDistance;
    
    const float SceneRaymarchStepIterator = 5000.0f;
    float sceneRaymarchStepIndex;
    
    while (sceneRaymarchStepIndex < SceneRaymarchStepIterator)
    {
        vec4 sceneRaymarchRaypointDataPosition = sceneCameraRaypointData.raypointDataPosition.xyzw + sceneRaymarchTraveledDistance * sceneCameraRaypointData.raypointDataDirection.xyzw;
        sceneRaymarchRaypointDataPosition.xyzw = getRaypointDataDefinedPosition(sceneRaymarchRaypointDataPosition.xyzw).xyzw;
        
        sceneRaymarchSurfaceData = getSceneSurfaceData(sceneRaymarchRaypointDataPosition.xyzw);
        
        sceneRaymarchEpsilon = max(NumericConstant_Epsilon, NumericConstant_Epsilon * sceneRaymarchTraveledDistance);
        
        if (abs(sceneRaymarchSurfaceData.surfaceDataSignedDistance) < sceneRaymarchEpsilon || sceneRaymarchTraveledDistance > CameraConstant_FarClippingPlane)
        {
            break;
        }
        
        sceneRaymarchTraveledDistance += sceneRaymarchSurfaceData.surfaceDataSignedDistance;
        
        sceneRaymarchStepIndex++;
    }
    
    sceneRaymarchSurfaceData.surfaceDataSignedDistance = sceneRaymarchTraveledDistance;
    
    return sceneRaymarchSurfaceData;
}

raypointData getSceneNormalRaypointData(const in raypointData sceneCameraRaypointData, const in surfaceData sceneRaymarchSurfaceData)
{
    vec4 sceneNormalRaypointDataPosition = sceneCameraRaypointData.raypointDataPosition.xyzw + sceneRaymarchSurfaceData.surfaceDataSignedDistance * sceneCameraRaypointData.raypointDataDirection.xyzw;
    sceneNormalRaypointDataPosition.xyzw = getRaypointDataDefinedPosition(sceneNormalRaypointDataPosition.xyzw).xyzw;
    
    const vec3 SceneNormalDirectionEpsilon = vec3(-NumericConstant_Epsilon, NumericConstant_Zero, NumericConstant_Epsilon).xyz;
    vec4 sceneNormalRaypointDataDirection;
    sceneNormalRaypointDataDirection.xyzw += getSceneSurfaceData(SceneNormalDirectionEpsilon.zxxy + sceneNormalRaypointDataPosition.xyzw).surfaceDataSignedDistance * SceneNormalDirectionEpsilon.zxxy;
    sceneNormalRaypointDataDirection.xyzw += getSceneSurfaceData(SceneNormalDirectionEpsilon.xzxy + sceneNormalRaypointDataPosition.xyzw).surfaceDataSignedDistance * SceneNormalDirectionEpsilon.xzxy;
    sceneNormalRaypointDataDirection.xyzw += getSceneSurfaceData(SceneNormalDirectionEpsilon.xxzy + sceneNormalRaypointDataPosition.xyzw).surfaceDataSignedDistance * SceneNormalDirectionEpsilon.xxzy;
    sceneNormalRaypointDataDirection.xyzw += getSceneSurfaceData(SceneNormalDirectionEpsilon.zzzy + sceneNormalRaypointDataPosition.xyzw).surfaceDataSignedDistance * SceneNormalDirectionEpsilon.zzzy;
    sceneNormalRaypointDataDirection.xyzw = getRaypointDataDefinedDirection(sceneNormalRaypointDataDirection.xyzw).xyzw;
    
    raypointData sceneNormalRaypointData;
    sceneNormalRaypointData.raypointDataPosition.xyzw = sceneNormalRaypointDataPosition.xyzw;
    sceneNormalRaypointData.raypointDataDirection.xyzw = sceneNormalRaypointDataDirection.xyzw;
    
    return sceneNormalRaypointData;
}

raypointData getSceneLightRaypointData(const in vec3 sceneLightTransformDataPosition, const in raypointData sceneNormalRaypointData)
{
    vec4 sceneLightRaypointDataPosition = getRaypointDataDefinedPosition(sceneLightTransformDataPosition.xyz).xyzw;
    
    vec4 sceneLightRaypointDataDirection = sceneLightRaypointDataPosition.xyzw - sceneNormalRaypointData.raypointDataPosition.xyzw;
    sceneLightRaypointDataDirection.xyzw = getRaypointDataDefinedDirection(sceneLightRaypointDataDirection.xyzw).xyzw;
    
    raypointData sceneLightRaypointData;
    sceneLightRaypointData.raypointDataPosition.xyzw = sceneLightRaypointDataPosition.xyzw;
    sceneLightRaypointData.raypointDataDirection.xyzw = sceneLightRaypointDataDirection.xyzw;
    
    return sceneLightRaypointData;
}

raypointData getSceneReflectionRaypointData(const in raypointData sceneLightRaypointData, const in raypointData sceneNormalRaypointData)
{
    vec4 sceneReflectionRaypointDataPosition = sceneNormalRaypointData.raypointDataPosition.xyzw;
    sceneReflectionRaypointDataPosition.xyzw = getRaypointDataDefinedPosition(sceneReflectionRaypointDataPosition.xyzw).xyzw;
    
    vec4 sceneReflectionRaypointDataDirection = reflect(sceneLightRaypointData.raypointDataDirection.xyzw, sceneNormalRaypointData.raypointDataDirection.xyzw).xyzw;
    sceneReflectionRaypointDataDirection.xyzw = getRaypointDataDefinedDirection(sceneReflectionRaypointDataDirection.xyzw).xyzw;
    
    raypointData sceneReflectionRaypointData;
    sceneReflectionRaypointData.raypointDataPosition.xyzw = sceneReflectionRaypointDataPosition.xyzw;
    sceneReflectionRaypointData.raypointDataDirection.xyzw = sceneReflectionRaypointDataDirection.xyzw;
    
    return sceneReflectionRaypointData;
}

vec4 getSceneSurfaceColorData(const in raypointData sceneCameraRaypointData, const in surfaceData sceneRaymarchSurfaceData)
{
    raypointData sceneNormalRaypointData = getSceneNormalRaypointData(sceneCameraRaypointData, sceneRaymarchSurfaceData);
    
    raypointData sceneLightRaypointData = getSceneLightRaypointData(vec3(36.0f, 36.0f, 0.0f).xyz, sceneNormalRaypointData);
    
    raypointData sceneReflectionRaypointData = getSceneReflectionRaypointData(sceneLightRaypointData, sceneNormalRaypointData);
    
    materialData sceneRaymarchMaterialData = getMaterialDataDefinedThis(sceneRaymarchSurfaceData.surfaceDataMaterialData);
    
    vec4 sceneRaymarchMaterialAmbientColor;
    {
        float sceneRaymarchMaterialAmbientAmount = sceneRaymarchMaterialData.materialDataAmbientAmount;
        
        sceneRaymarchMaterialAmbientColor.rgba = getColorDataDefinedThis(sceneRaymarchMaterialAmbientAmount).rgba;
    }
    
    vec4 sceneRaymarchMaterialDiffuseColor;
    {
        float sceneRaymarchMaterialDiffuseAmount = dot(sceneLightRaypointData.raypointDataDirection.xyzw, sceneNormalRaypointData.raypointDataDirection.xyzw);
        sceneRaymarchMaterialDiffuseAmount = getFloatDataClampedFromZeroToOneThis(sceneRaymarchMaterialDiffuseAmount);
        sceneRaymarchMaterialDiffuseAmount *= sceneRaymarchMaterialData.materialDataDiffuseAmount;
        
        sceneRaymarchMaterialDiffuseColor.rgba = getColorDataDefinedThis(sceneRaymarchMaterialDiffuseAmount).rgba;
    }
    
    vec4 sceneRaymarchMaterialSpecularColor;
    {
        float sceneRaymarchMaterialSpecularShininess;
        {
            const float SceneRaymarchMaterialSoftSpecular = 16.0f;
            const float SceneRaymarchMaterialSharpSpecular = 128.0f;
            
            sceneRaymarchMaterialSpecularShininess = SceneRaymarchMaterialSoftSpecular + (SceneRaymarchMaterialSharpSpecular - SceneRaymarchMaterialSoftSpecular) * sceneRaymarchMaterialData.materialDataSpecularShininess;
            sceneRaymarchMaterialSpecularShininess = clamp(sceneRaymarchMaterialSpecularShininess, SceneRaymarchMaterialSoftSpecular, SceneRaymarchMaterialSharpSpecular);
        }
        
        float sceneRaymarchMaterialSpecularAmount = dot(sceneCameraRaypointData.raypointDataDirection.xyzw, sceneReflectionRaypointData.raypointDataDirection.xyzw);
        sceneRaymarchMaterialSpecularAmount = getFloatDataClampedFromZeroToOneThis(sceneRaymarchMaterialSpecularAmount);
        sceneRaymarchMaterialSpecularAmount = pow(sceneRaymarchMaterialSpecularAmount, sceneRaymarchMaterialSpecularShininess);
        sceneRaymarchMaterialSpecularAmount *= sceneRaymarchMaterialData.materialDataSpecularAmount;
        
        sceneRaymarchMaterialSpecularColor.rgba = getColorDataDefinedThis(sceneRaymarchMaterialSpecularAmount).rgba;
    }
    
    vec4 sceneRaymarchMaterialPhongColor;
    sceneRaymarchMaterialPhongColor.rgba += sceneRaymarchMaterialAmbientColor.rgba;
    sceneRaymarchMaterialPhongColor.rgba += sceneRaymarchMaterialDiffuseColor.rgba;
    sceneRaymarchMaterialPhongColor.rgba += sceneRaymarchMaterialSpecularColor.rgba;
    sceneRaymarchMaterialPhongColor.rgba *= sceneRaymarchMaterialData.materialDataGeneralColor.rgba;
    sceneRaymarchMaterialPhongColor.rgba = getColorDataDefinedThis(sceneRaymarchMaterialPhongColor.rgba).rgba;
    
    vec4 sceneSurfaceGammaCorrectionColor = getColorDataDefinedThis(NumericConstant_Gamma).rgba;
    
    vec4 sceneSurfaceColorData = pow(sceneRaymarchMaterialPhongColor.rgba, sceneSurfaceGammaCorrectionColor.rgba).rgba;
    sceneSurfaceColorData.rgba = getColorDataDefinedThis(sceneSurfaceColorData.rgba).rgba;
    
    return sceneSurfaceColorData.rgba;
}

vec4 getSceneBackgroundColorData(const in vec2 sceneCameraViewportCoordinates)
{
    vec4 sceneBackgroundColorData = getColorDataDefinedThis(0.25f).rgba;
    
    return sceneBackgroundColorData.rgba;
}

void mainImage(out vec4 fragmentOutputColor, in vec2 fragmentInputCoordinates)
{
    vec2 sceneCameraViewportCoordinates = (2.0f * fragmentInputCoordinates.xy - iResolution.xy).xy / min(iResolution.x, iResolution.y);
    
    raypointData sceneCameraRaypointData = getSceneCameraRaypointData(vec3(-6.0f, 18.0f, 0.0f).xyz, Scene_PointOfViewPosition.xyz, sceneCameraViewportCoordinates.xy, 30.0f);
    
    surfaceData sceneRaymarchSurfaceData = getSceneRaymarchSurfaceData(sceneCameraRaypointData);
    
    if (sceneRaymarchSurfaceData.surfaceDataSignedDistance < CameraConstant_FarClippingPlane)
    {
        fragmentOutputColor.rgba = getSceneSurfaceColorData(sceneCameraRaypointData, sceneRaymarchSurfaceData).rgba;
    }
    else
    {
        fragmentOutputColor.rgba = getSceneBackgroundColorData(sceneCameraViewportCoordinates.xy).rgba;
    }
}