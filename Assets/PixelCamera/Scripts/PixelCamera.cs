using System;
using UnityEngine;

namespace PixelCamera
{
    [ExecuteInEditMode]
    [RequireComponent(typeof(Camera))]
    public class PixelCamera : MonoBehaviour
    {
        public void Start()
        {
            if (shaderMaterials == null || shaderMaterials.Length == 0) throw new ArgumentNullException("shaderMaterials");
            SetUsedShader(defaultShaderIndex);
        }

        public void CycleUsedShader()
        {
            shaderIndex++;
            if (shaderIndex >= shaderMaterials.Length) shaderIndex = 0;

            UpdateShader();
        }

        public void SetUsedShader(int index)
        {
            if (index < 0 || index >= shaderMaterials.Length) throw new ArgumentOutOfRangeException("index");
            shaderIndex = index;

            UpdateShader();
        }

        private void UpdateShader()
        {
            shaderMaterial = shaderMaterials[shaderIndex];
        }

        public void OnRenderImage(RenderTexture source, RenderTexture destination)
        {
            if (shaderMaterial == null) return;

            shaderMaterial.SetTexture("_SourceTex", sourceBuffer);
            shaderMaterial.SetVector("_SourceParams", new Vector4(sourceBuffer.width, sourceBuffer.height));

            Graphics.Blit(sourceBuffer, destination, shaderMaterial);
        }

        private Material shaderMaterial;
        private int shaderIndex;
                
        [SerializeField]
        private Material[] shaderMaterials;
        [SerializeField]
        private int defaultShaderIndex = 0;
        [SerializeField]
        private RenderTexture sourceBuffer;
    }    
}
