from PIL import Image
import scipy.fftpack as spfft
import cvxpy as cvx
from datetime import datetime
import numpy as np

"""

1/ Compressive sensing :

We "smart sample" : measurements = m_matrix * image_as_vector


2/ Decompression :

To reconstruct the original *DCT parameters* (not the original picture !),
we find x such that : measumrents = m_matrix * inverse_dct * x (x is min in 1-norm)

Once we have the parameters in x, we can revuild the original image with inverse_dct * x

"""

image = Image.open('gorgone2.png')
assert "L" == image.mode, "I only work on grayscale images"
data = np.asarray(image)
N = data.shape[0]
assert N == data.shape[1], "I only work on square images"

# We drop 75% of the original image
M = int(N*N*0.25)

img_as_vector = data.reshape((N*N, 1))

# Various measurements matrices are possible
#m_matrix = np.random.binomial(1, 0.5, (M, N*N))
m_matrix = np.random.randn(M, N*N)

measurements = np.matmul(m_matrix, img_as_vector).reshape((M,))

# Found here :
# http://www.pyrunner.com/weblog/2016/05/26/compressed-sensing-python/
idct_matrix = np.kron(
    spfft.idct(np.identity(N), norm='ortho', axis=0),
    spfft.idct(np.identity(N), norm='ortho', axis=0))

cs_matrix = np.matmul(m_matrix, idct_matrix)

print(f"cs matrix shape = {cs_matrix.shape}, measurements shape = {measurements.shape}")

x = cvx.Variable(N*N) #b is dim x
objective = cvx.Minimize(cvx.norm(x,1)) #L_1 norm objective function
constraints = [cs_matrix @ x == measurements] #y is dim a and M is dim a by b
prob = cvx.Problem(objective, constraints)
result = prob.solve(verbose=True)

def idct2(x):
    # Inverse DCT in 2D
    return spfft.idct(spfft.idct(x.T, norm='ortho', axis=0).T, norm='ortho', axis=0)

decompressed = idct2(np.array(x.value).reshape((N,N)))

img = Image.fromarray(decompressed)
img.show()

exit()




# decompressed.show()


print("Compressive sensing.. Building matrix")

print(datetime.now())

dctl = np.zeros((N*N, N*N))
for i in range(N):
    for j in range(N):
        dctl[i*N + j, j*N:(j+1)*N] = dct_inv[i, :]

measurements = np.random.randn(int(N*N*0.8),N*N)


cs_matrix = np.matmul(measurements, dctl)
#cs_matrix[cs_matrix < 0.1] = 0


# decimate = int(N*N*0.2)
# print("Removing {} pixels".format(int(N*N*0.2)))
# for i in range(decimate):
#     ndx = int(np.random.random()*cs_matrix.shape[0])
#     cs_matrix = np.delete(cs_matrix, ndx, 0)
cs_matrix *= np.sum(cs_matrix)

print(datetime.now())

if False:
    # Testing DCT code only

    print("Compressive sensing.. Compressing DCT only")
    compressed = np.matmul(dctl, data.reshape((N*N,1)))
    print("quantizing")
    compressed[ abs(compressed) < 210] = 0
    print("Sparseness = {:.0f}%".format(100 - 100*np.count_nonzero(compressed) / (N**2)))

    print("decompressing DCT only")
    decompressed = Image.fromarray( np.matmul(np.linalg.inv(dctl), compressed).reshape((N,N)))
    decompressed.show()


print("Compressive sensing.. Compressing and sensing")
compressed = np.matmul(cs_matrix, data.reshape((N*N,)))

print(compressed.shape)

print("Compressive sensing - decompressing")




x = cvx.Variable(N*N) #b is dim x
objective = cvx.Minimize(cvx.norm(x,1)) #L_1 norm objective function
constraints = [cs_matrix @ x == compressed] #y is dim a and M is dim a by b
prob = cvx.Problem(objective,constraints)
result = prob.solve(verbose=True)

#then clean up and chop the 1e-12 vals out of the solution
x = np.array(x.value) #extract array from variable

print(datetime.now())

#x = np.array([a for b in x for a in b]) #unpack the extra brackets
#x[np.abs(x)<1e-9]=0 #chop small numbers to 0

decompressed = Image.fromarray( x.reshape((N,N)))
decompressed.show()
