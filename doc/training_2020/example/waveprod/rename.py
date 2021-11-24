# import os
# import argparse
# def parse():
#     parser = argparse.ArgumentParser(description='批量修改文件名')
#     parser.add_argument('target_dir', metavar='TARGET_DIR', type=str, nargs=1, help='需批量修改文件所在目录')
#     parser.add_argument('delete_part', metavar='DELETE_PART', type=str, nargs=1, help='删除字段')
#     return parser
#
#
# def filename_del(target_dir, delete_part):
#     try:
#         # delete_part = '【程序员教程吧 论 坛 www.cxyjc8.com】'
#         for filename in os.listdir(target_dir):
#             file = os.path.splitext(filename)
#             file_ext = file[1]
#             a = '\\'
#             dir = target_dir + str(a) + file[0]
#             if len(file_ext) == 0:
#                 filename_del(dir, delete_part)
#             else:
#                 newname = filename.replace(delete_part, '')
#                 print(newname)
#                 os.rename(
#                     os.path.join(target_dir, filename),
#                     os.path.join(target_dir, newname)
#                 )
#     except Exception:
#         print('不是文件夹')
#
#
# def main():
#     parser = parse()
#     args = vars(parser.parse_args())
#     work_dir = args['target_dir'][0]
#     delete_part = args['delete_part'][0]
#
#     filename_del(work_dir, delete_part)
#
#
# if __name__ == '__main__':
#     main()


import os

all_file = []
root = os.getcwd()


def file_name(file_dir):
    for roots, dirs, files in os.walk(file_dir):
        print("所在目录:", roots)
        print("所在目录的,所有目录名:", dirs)
        print("所在目录的所有非目录文件名:", files)
        # filepath = os.path.join(file_dir,dirs)
        os.listdir()
        for i in files:
            if i in ['getname.py', '2017-01-06_RoyalBarge_1920x1080.jpg',
                     '2017-01-10_EifelNPBelgium_1920x1080.jpg']:  # 这里添加你需要进行保留的图片名称,全名用单引号和逗号进行隔离
                print("此图片已经保留", i)
            else:
                print("此图片删除中", i)
                os.remove(i)


def remove(str):
    """
    :param str:是你要删除的文件的特点 比如 这些文件都有‘.+’ 那么就传入'.+'
    :return: 无
    """
    for i in all_file:
        if str in i:
            os.remove(i)


def del_files(path):
    for root, dirs, files in os.walk(path):
        for name in files:
            if name.startswith("INCAR"):
                # os.remove(os.path.join(root, name))
                print("Delete File: " + os.path.join(root, name))


if __name__ == '__main__':
    # file_name(root)
    # path1 = "/run"
    # path = os.path.join(root, path1)
    del_files(root)
