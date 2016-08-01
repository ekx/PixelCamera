using UnityEngine;
using System.Collections;

namespace PixelCamera.Examples
{
    public class ExampleController : MonoBehaviour
    {
        void Update()
        {
            if (Input.GetKeyDown(KeyCode.Space) || Input.GetKeyDown(KeyCode.Return) || Input.GetMouseButtonDown(0))
            {
                pixelCamera.CycleUsedShader();
            }
        }

        [SerializeField]
        private PixelCamera pixelCamera;
    }
}