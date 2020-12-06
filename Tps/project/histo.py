import re
from PIL import Image
import numpy as np
import matplotlib.pyplot as plt
from scipy import fftpack
from matplotlib.colors import LogNorm

def name_cvt( name):
    s = name
    s = s.replace("Robust","Variant ")
    s = s.replace("_ep_", " Eps=")
    s = s.replace(".png","")
    s = s.replace("noisy_"," M")
    s = s.replace("_",",")
    s = re.sub(r',10+',",1",s)
    return s

ORIGINAL_IMAGE = "L1_newuncorrupted_3042.png"


im1 = Image.open(ORIGINAL_IMAGE).convert('L')

NAME1 = "Robust1_ep_0_100000noisy_1014.png"
NAME2 = "Robust1_ep_0_001000noisy_1014.png"


im2 = Image.open(NAME1).convert('L')
im3 = Image.open(NAME2).convert('L')


aim1 = np.array(im1, dtype=int)
aim2 = np.array(im2, dtype=int)
aim3 = np.array(im3, dtype=int)

BINS = 64
hist = np.histogram(aim1 - aim2, bins=BINS)
hist2 = np.histogram(aim1 - aim3, bins=BINS)

plt.figure()
plt.plot(hist[1][0:len(hist[0])], hist[0], label=name_cvt(NAME1))
plt.plot(hist2[1][0:len(hist2[0])], hist2[0], label=name_cvt(NAME2))
plt.title("Noise histogram")
plt.legend()
plt.savefig(f"histo_{NAME1}")




def plot_spectrum(name, im):
    n1 = np.abs(im  / np.max(im))
    im_fft = fftpack.fftshift( fftpack.fft2(n1))

    # A logarithmic colormap
    plt.imshow(np.abs(im_fft), norm=LogNorm(vmin=5))
    plt.colorbar()
    plt.title("FFT decompressed " + name_cvt(name))


# im_fft = im_fft  / np.max(im_fft)
# print(im_fft)

plt.figure()
plot_spectrum(NAME1, aim2)
plt.savefig(f"fft_{NAME1}")
plt.figure()
plot_spectrum(NAME2, aim3)
plt.savefig(f"fft_{NAME2}")
plt.show()
