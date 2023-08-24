#IMPORTS----------------------------------------------------------------------------------------------------
import pytesseract
from pytesseract import Output
from PIL import Image
import cv2
pytesseract.pytesseract.tesseract_cmd = 'C:\Program Files\Tesseract-OCR\\tesseract.exe'

#INPUT IMAGE PATH-------------------------------------------------------------------------------------------

img_path1 = 'Imgs/Screenshot.png'

#IMAGE OCR AND HANDLING-------------------------------------------------------------------------------------

visu = True

text = pytesseract.image_to_string(img_path1,lang='eng')
lines = text.split('\n')
refined_text = [line for line in lines if line != '']
refined_text = [str('0 ' + line).split(' ') if not line[0].isnumeric() else line.split(' ') for line in refined_text]
refined_text = [[word.strip('s') for word in refined_text[i]] for i in range(len(refined_text))]

caracs_value_str = [line[0].strip('%') for line in refined_text]
caracs_name = [' '.join(line[1:]) for line in refined_text]

if visu :
    with open("OCRout.txt","w") as file :
        for name, value in zip(caracs_name, caracs_value_str) : #Does not take last line (1PA)
            print(name + ' : '  + value)
            file.write(name + ' : '  + value + '\n')

caracs_value_int = [int(carac) for carac in caracs_value_str]

caracs = dict(zip(caracs_name, caracs_value_int)) #Format : "Name : Value (int)" for each line naturally present in the object

#DECISION MAKING--------------------------------------------------------------------------------------------

try :
    with open('feedback.txt','w') as file : #File to communicate with the bot

        #TODO : Optimize this process of decision. Either manually for each item or try to make a general rule.
        #Manual approach is selected for now

        if(caracs['Critique'] < 3) :
            file.write('1CRI') #Rune do eau
        elif(caracs['Sagesse'] < 13) :
            file.write('3SAG') #Rune pa sa
        elif(caracs['Dommage Eau'] < 5) :
            file.write('1DOE') #Rune do eau
        elif(caracs['Dommage Terre'] < 5) :
            file.write('1DOT') #Rune do terre
        elif(caracs['Dommage Neutre'] < 5) :
            file.write('1DON') 
        else : file.write('EXIT')
except Exception as error:
    with open('feedback.txt','w') as file :
        file.write(f"An error occurred: {error}")

#Note dev : la reconnaissance de texte foire des qu'il y a plusieurs colonnes de caracs (par exemple min-max). 
#Avec une seule colonne de caracs ou avec colonne + nom de la carac, aucun probleme sauf pour le PA

#V0 TODO : Gerer les lignes vides