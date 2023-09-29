import os, shutil

class FileSorter:
    def get_path(self):
        path = r"file path"
        return path

    def get_files_in_directory(self, path):
        all_files = os.listdir(path)
        print(f"All the files in {path} are {all_files} ")
        return all_files
    
    def create_folder(self,path):
        folder_names = ['/csv files', '/image files', '/text files']
        for loop in range(len(folder_names)):
            if not os.path.exists(path + folder_names[loop]):
                print(path + folder_names[loop])
                os.makedirs(path + folder_names[loop])
    
    def sort_files(self, files_list, path):
        for file in files_list:
            print(f"File read:  {file}")
            if ".DS_Store" in file:
                continue
            elif ".csv" in file or ".xlsx" in file and not os.path.exists(path + "/csv files/" + file):
                shutil.move(path + "/" + file, path + "/csv files/" + file)
            elif ".png" in file or ".jpeg" in file and not os.path.exists(path + "/image files/" + file):
                shutil.move(path + "/" + file, path + "/image files/" + file)
            elif ".txt" in file or ".pdf" in file or "docx" in file and not os.path.exists(path + "/text files/" + file):
                shutil.move(path + "/" + file, path + "/text files/" + file)
            else:
                print("This file type is not moved!! folder not found..")

obj = FileSorter()
path = obj.get_path()
files = obj.get_files_in_directory(path)
obj.create_folder(path)
obj.sort_files(files, path)
