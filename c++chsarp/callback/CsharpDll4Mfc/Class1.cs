using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading.Tasks;

namespace CsharpDll4Mfc
{
    [ComVisible(true)]
    [Guid("9A26F178-28D6-43AC-9C1A-2CD9F9D01246")]
    [InterfaceType(ComInterfaceType.InterfaceIsIDispatch)]
    public interface ICalculator
    {
        [DispId(1)]
        int Add(int Number1, int Number2);

        [DispId(2)]
        int testCallBack(int kk, long callback);
    }

    [TypeLibType(4160)]
    [ComVisible(true), ComSourceInterfaces(typeof(ICalculator))]
    [Guid("B1612D7D-3DB0-4CC3-8C3C-3504CBC77BAD")]
    [ProgId("CsharpDll4Mfc.Class1")]
    public class Class1 : ICalculator
    {
        public int Add(int Number1, int Number2)
        {
            return Number1 * Number2;
        }

        public int testCallBack(int kk, long callback)
        {
            ProgressCallback p = (ProgressCallback)Marshal.GetDelegateForFunctionPointer(new IntPtr(callback), typeof(ProgressCallback));
            int dd = kk + 1000;
            return p(dd);
        }

        [UnmanagedFunctionPointerAttribute(CallingConvention.StdCall, CharSet = CharSet.Ansi)]
        public delegate int ProgressCallback(int kk);


        public void Initialize()
        {
            //nothing todo
        }
        public void Dispose()
        {
            //nothing todo
        }
    }
}
