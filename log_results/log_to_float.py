from pathlib import Path

if __name__ == "__main__":
    log_file = open(input("Enter input filename:"))
    output = input("Enter output filename:")
    Path(output).touch()
    float_file = open(output,'w')
    log_num = log_file.readline()
    log_sign = log_file.readline()
    while log_num != "" and log_sign != "":
        if int(log_sign):
            float_file.write(str((2**float(log_num)))+ "\n")
        else:
            float_file.write(str(0 - (2**float(log_num)))+ "\n")
        log_num = log_file.readline()
        log_sign = log_file.readline()

            
    