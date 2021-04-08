import math
#Note: These functions are taken directly from geeksforgeeks.
#link: https://www.geeksforgeeks.org/python-program-to-convert-any-positive-real-number-to-binary-string/

def stringsize(s):
    size = 0
    for i in s:
        size = size + 1
    return size
def bitcorrect(s,bits):
    adder = s[0]
    while stringsize(s) < bits:
        s = adder + s
    return s
def float_to_binary(x, m, n):
    """Convert the float value `x` to a binary string of length `m + n`
    where the first `m` binary digits are the integer part and the last
    'n' binary digits are the fractional part of `x`.
    """
    x_scaled = round(x * 2 ** n)
    return '{:0{}b}'.format(x_scaled, m + n)

def binary_to_float(bstr, m, n):
    """Convert a binary string in the format given above to its float
    value.
    """
    return int(bstr, 2) / 2 ** n

def negate_binary(bin):
    bin = "0"+bin[1:]
    test = ""
    for x in bin:
        if x == '0':
            test = test + '1'
        else:
            test = test + '0'
    test =  test[::-1]
    carry = 0
    sum = 1
    position = 0
    test = list(test)
    for x in test:
        if x == '0' and (sum == 1 or carry == 1):
            test[position] = '1'
            sum = 0
            test = "".join(test)
            return str(test[::-1])
        elif x == '1' and (sum == 1 or carry == 1):
            carry = 1
            sum = 0
            test[position] = '0'
        else:
            return str(test[::-1])
        position = position + 1

if __name__ =="__main__":
    print("Provide range of values covered, and the bit_size you want them expressed as:")

    range_values = int(input("Range:"))
    bit_size = int(input("Bit-size:"))
    decimal_size = int(input("Decimal-size"))
    #decimal_size = bit_size - 5
    curr_value = 0
    incrementor = 2**(-decimal_size)
    f = open("LogTableRange"+str(range_values)+"bits"+str(bit_size) + "_" + str(decimal_size)+".v", "a")
    f.write("module Tables();\n")
    #Add to this line to get right bit size.
    f.write("\treg ["+str(bit_size + decimal_size-1)+":0] logarithm_table["+str((range_values*(2**decimal_size))-1)+":0];\n")
    f.write("\treg ["+str(bit_size-1 + decimal_size) + ":0] Dplus["+str((range_values*(2**decimal_size))-1)+":0];\n")
    f.write("\treg ["+str(bit_size-1 + decimal_size) +":0] Dminus["+str((range_values*(2**decimal_size))-1)+":0];\n")
    f.write("\tinitial begin\n")
    entry_value = 1
    #This portion of the code generates the logarithm table values.
    while curr_value < range_values:
        if curr_value != 0:
            temp = float_to_binary(math.log(curr_value,2),bit_size,decimal_size)
            if temp[0] != '-':
                temp = temp[0:bit_size] + '_' + temp[bit_size:]
                #print(math.log(curr_value,2))
                f.write("\t\tlogarithm_table["+str(entry_value)+"] = "+str(bit_size + decimal_size)+"'b"+str(temp)+";\n")
                #print(temp)
            else:
                temp = negate_binary(temp)
                temp = temp[0:bit_size] + '_' + temp[bit_size:]
                #print(math.log(curr_value,2))
                f.write("\t\tlogarithm_table["+str(entry_value)+"] = "+str(bit_size + decimal_size)+"'b"+str(temp)+";\n")
                #print(temp)
            entry_value = entry_value + 1
        else:
            print()
        curr_value = curr_value + incrementor
    curr_value = incrementor
    entry_value = 1
    #This portion here generates the delta minus table.
    while curr_value < range_values:
        #print()
        x = math.log(1 - 2**(-curr_value),2)
        temp = float_to_binary(x,bit_size,decimal_size)
        if temp[0] != '-':
            temp = temp[0:bit_size] + '_' + temp[bit_size:]
            #print(math.log(curr_value,2))
            f.write("\t\tDminus["+str(entry_value)+"] = "+str(bit_size + decimal_size)+"'b"+str(temp)+";\n")
            #print(temp)
        else:
            temp = negate_binary(temp)
            temp = temp[0:bit_size] + '_' + temp[bit_size:]
            #print(math.log(curr_value,2))
            f.write("\t\tDminus["+str(entry_value)+"] = "+str(bit_size + decimal_size)+"'b"+str(temp)+";\n")
            #print(temp)
        curr_value = curr_value + incrementor
        entry_value = entry_value + 1
    curr_value = incrementor
    entry_value = 1
    #This portion here generates the delta minus table.
    while curr_value < range_values:
        x = math.log(1 + 2**(-curr_value),2)
        temp = float_to_binary(x,bit_size,decimal_size)
        if temp[0] != '-':
            temp = temp[0:bit_size] + '_' + temp[bit_size:]
            f.write("\t\tDplus["+str(entry_value)+"] = "+str(bit_size + decimal_size)+"'b"+str(temp)+";\n")
        else:
            temp = negate_binary(temp)
            temp = temp[0:bit_size] + '_' + temp[bit_size:]
            #print(math.log(curr_value,2))
            f.write("\t\tDplus["+str(entry_value)+"] = "+str(bit_size + decimal_size)+"'b"+str(temp)+";\n")
            #print(temp)
        curr_value = curr_value + incrementor
        entry_value = entry_value + 1
    f.write("end\n")
    f.write("endmodule\n")
