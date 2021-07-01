from tool._fixedInt import *

a=DeFixedInt(6,5,'S','round','saturate')
b=DeFixedInt(6,5,'S','round','saturate')

a.value = 0.758
b.value = 0.913

print(a.fValue)
print(b.fValue)

print("a_bin =",bin(a.intvalue)[2:].zfill(a.width))
print("b_bin =",bin(b.intvalue)[2:].zfill(b.width))

a.showRange()
b.showRange()

c = a * b
print("\nc_flt =",c.fValue)
print(c.rep)
c.showRange()
print("c_bin =",bin(c.intvalue)[2:].zfill(c.width))

c_trn=DeFixedInt(6,5,'S','round','saturate')

c_trn.value = c.fValue
print("\nc_trn_flt =",c_trn.fValue)
c_trn.showRange()
print("c_trn_bin =",bin(c_trn.intvalue)[2:].zfill(c_trn.width))
