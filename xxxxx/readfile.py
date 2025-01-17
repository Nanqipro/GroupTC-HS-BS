# 打开文件
# file_path = "/home/LiJB/cuda_project/TC-compare-V100/build/logs/polak.txt"  # 文件路径

def readfile(file_path):
    lines = []
    try:
        with open(file_path, 'r') as file:
            # 按行读取文件内容
            for line in file:
                # print(line.strip())  # 使用 strip() 方法去除每行末尾的换行符
                lines.append(line.split("[info]")[1].strip())
    except FileNotFoundError:
        print(f"文件 '{file_path}' 不存在。")
    except IOError as e:
        print(f"无法打开文件 '{file_path}'：{e}")
    return lines

unchecked_lines = readfile ( "/home/LiJB/cuda_project/TC-compare-V100/build/logs/fox.txt")
checked_lines = readfile ( "/home/LiJB/cuda_project/TC-compare-V100/build/logs/bisson.txt")


size = len(checked_lines)
for i in range(size):
    if unchecked_lines[i] != checked_lines[i]:
        print(unchecked_lines[i],checked_lines[i])


# count = 0
# ss = string.split("\n")
# for s in ss:
#     count +=  int(s.split(" ")[1])

# print(count)
# polak_lines = polak_string.split("\n")
# tc_check_lines = tc_check_string.split("\n")
# size = len(polak_lines)
# for i in range(size):
#     if polak_lines[i] != tc_check_lines[i]:
#         print(polak_lines[i],tc_check_lines[i])
#     else:
#         print()


# global: 9897, 32
# shared: 4, 16