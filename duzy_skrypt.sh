#!/bin/bash

#	HEAD
#
# Author           : Piotr 'Sunnivran' Żakowski ( piotrek-zakowski@wp.pl )
# Created On       : 27.05.2016
# Last Modified By : Piotr 'Sunnivran' Żakowski ( piotrek-zakowski@wp.pl )
# Last Modified On : 28.05.2016
# Version          : 1.1
#
# Description      : Program służący do kompresji i dekompresji. 
# Opis
#
# Program służący do kompresji i dekompresji (.zip | .tar | .tar.gz | .tar.bz2 | .rar ).
# Ponadto dla rozszerzeń .zip i .rar przewidziana jest opcja zabezpieczenia archiwum hasłem.
#
# PARAMETRY KONSOLOWE:
# 	h - help - pomoc
#	q - quit - wyjście, kończy prace programu
#	g - graphic - opcja graficzna w Dialogu
#	p - pack - zapakuj, wykonaj kompresje
#	u -	unpack - rozpakuj, wykonaj dekompresje
#	s - source - źródło, dodanie pełnej ścieżki do pliku
#	d - destination - docelowe miejsce, dodanie pełnej ścieżki do folderu docelowego
#	n - (new) name - nowa nazwa, nazwa wynikowego archiwum przy kompresji
#	w - password - hasło
#	e - extension - rozszerzenie, na jej podstawie program wykonuje odpowiednie dla danego 
#		rozszerzenia kompresje i dekompresje
#
#	END OF HEAD


TYTUL="ArchiveZ"
SCIEZKA_FOLDERU_SKRYPTU=$(dirname "$0")
PRZYCISK_OK=0
PRZYCISK_CANCEL=1
PRZYCISK_YES=0
PRZYCISK_NO=1

PRZYCISK=''
HASLO=''
SCIEZKA_ZRODLOWA=''
SCIEZKA_DOCELOWA=''
NOWA_NAZWA=''
ROZSZERZENIE=''

#### FUNKCJE UNIWERSALNE ####
pozegnanie(){
	OKNO=`dialog --stdout --title $TYTUL --msgbox "\nDziękujemy za skorzystanie z programu. Do zobaczenia =)" 8 60`
}

podaj_dane(){
	OKNO=`dialog --stdout --title $TYTUL --inputbox "Wpisz ścieżkę źródłową pliku" 8 60 $SCIEZKA_ZRODLOWA`
	SCIEZKA_ZRODLOWA=$OKNO
	OKNO=`dialog --stdout --title $TYTUL --inputbox "Wpisz ścieżkę docelowego folderu" 8 60 $SCIEZKA_DOCELOWA`
	SCIEZKA_DOCELOWA=$OKNO
}

podaj_haslo(){
	OKNO=`dialog --stdout --title $TYTUL --inputbox "Wpisz hasło" 8 60`
	HASLO=$OKNO
}

zabezpiecz(){
	WARTOSC=`dialog --stdout --title $TYTUL --yesno "Czy zabezpieczyć hasłem?" 8 60 `
	PRZYCISK=$?
	case $PRZYCISK in
		$PRZYCISK_YES)
			podaj_haslo;;
		$PRZYCISK_NO)
			HASLO='';;
	esac
}

#### FUNKCJE OBSŁUGI PAKOWANIA ####

zip_pack(){
	if [ -z "$HASLO" ]; then
		eval "zip -r $SCIEZKA_DOCELOWA/$NOWA_NAZWA.zip $SCIEZKA_ZRODLOWA"
	else
		eval "zip -r $SCIEZKA_DOCELOWA/$NOWA_NAZWA.zip $SCIEZKA_ZRODLOWA -P $HASLO"
	fi
}

pakowanie_zip(){
	zabezpiecz
	OKNO=`dialog --stdout --title $TYTUL --yesno "Czy podane dane się zgadzają?\n\nŚcieżka źródłowa: $SCIEZKA_ZRODLOWA\nŚcieżka docelowa: $SCIEZKA_DOCELOWA\nNazwa docelowa pliku: $NOWA_NAZWA\nHasło*:$HASLO\nTyp archiwizacji: .zip\n*puste pole oznacza brak hasła" 12 60`
	PRZYCISK=$?
	case $PRZYCISK in
		$PRZYCISK_YES)
			zip_pack;;
		$PRZYCISK_NO)
			pakowanie;;
	esac
}

tar_pack(){
	eval "tar -cvf $SCIEZKA_DOCELOWA/$NOWA_NAZWA.tar $SCIEZKA_ZRODLOWA"
}

pakowanie_tar(){	
	OKNO=`dialog --stdout --title $TYTUL --yesno "Czy podane dane się zgadzają?\n\nŚcieżka źródłowa: $SCIEZKA_ZRODLOWA\nŚcieżka docelowa: $SCIEZKA_DOCELOWA\nNazwa docelowa pliku: $NOWA_NAZWA\nTyp archiwizacji: .tar" 12 60`
	PRZYCISK=$?
	case $PRZYCISK in
		$PRZYCISK_YES)
			tar_pack;;
		$PRZYCISK_NO)
			pakowanie;;
	esac
}

tar_gz_pack(){
	eval "tar -zcvf $SCIEZKA_DOCELOWA/$NOWA_NAZWA.tar.gz $SCIEZKA_ZRODLOWA"
}

pakowanie_tar_gz(){
	OKNO=`dialog --stdout --title $TYTUL --yesno "Czy podane dane się zgadzają?\n\nŚcieżka źródłowa: $SCIEZKA_ZRODLOWA\nŚcieżka docelowa: $SCIEZKA_DOCELOWA\nNazwa docelowa pliku: $NOWA_NAZWA\nTyp archiwizacji: .tar.gz" 12 60`
	PRZYCISK=$?
	case $PRZYCISK in
		$PRZYCISK_YES)
			tar_gz_pack;;
		$PRZYCISK_NO)
			pakowanie;;
	esac
}

tar_bz2_pack(){
	eval "tar -jcvf $SCIEZKA_DOCELOWA/$NOWA_NAZWA.tar.bz2 $SCIEZKA_ZRODLOWA"
}

pakowanie_tar_bz2(){
	OKNO=`dialog --stdout --title $TYTUL --yesno "Czy podane dane się zgadzają?\n\nŚcieżka źródłowa: $SCIEZKA_ZRODLOWA\nŚcieżka docelowa: $SCIEZKA_DOCELOWA\nNazwa docelowa pliku: $NOWA_NAZWA\nTyp archiwizacji: .tar.bz2" 12 60`
	PRZYCISK=$?
	case $PRZYCISK in
		$PRZYCISK_YES)
			tar_bz2_pack;;
		$PRZYCISK_NO)
			pakowanie;;
	esac
}

rar_pack(){
	if [ -z "$HASLO" ]; then
		eval "rar a $SCIEZKA_DOCELOWA/$NOWA_NAZWA.rar $SCIEZKA_ZRODLOWA"
	else
		eval "rar a $SCIEZKA_DOCELOWA/$NOWA_NAZWA.rar $SCIEZKA_ZRODLOWA -P$HASLO"
	fi
}

pakowanie_rar(){
	zabezpiecz
	OKNO=`dialog --stdout --title $TYTUL --yesno "Czy podane dane się zgadzają?\n\nŚcieżka źródłowa: $SCIEZKA_ZRODLOWA\nŚcieżka docelowa: $SCIEZKA_DOCELOWA\nNazwa docelowa pliku: $NOWA_NAZWA\nHasło*:$HASLO\nTyp archiwizacji: .rar\n*puste pole oznacza brak hasła" 12 60`
	PRZYCISK=$?
	case $PRZYCISK in
		$PRZYCISK_YES)
			rar_pack;;
		$PRZYCISK_NO)
			pakowanie;;
	esac
}

pakowanie(){
	podaj_dane
	OKNO=`dialog --stdout --title $TYTUL --inputbox "Wpisz nazwę archiwum." 8 60 $NOWA_NAZWA`
	NOWA_NAZWA=$OKNO
	OKNO=`dialog --stdout --title $TYTUL --menu "Wybierz format archiwum [format .zip oraz .rar posiadają możliwość zabezpieczenia hasłem]:" 15 60 5 "1" ".zip" "2" ".tar" "3" ".tar.gz" "4" ".tar.bz2" "5" ".rar"`
	PRZYCISK=$?
	case $PRZYCISK in
		$PRZYCISK_CANCEL)
			start;;
		$PRZYCISK_OK)
			case $OKNO in
				1) pakowanie_zip;;
				2) pakowanie_tar;;
				3) pakowanie_tar_gz;;
				4) pakowanie_tar_bz2;;
				5) pakowanie_rar;;
			esac
	esac
	start
}

#### FUNKCJE OBSŁUGI ROZPAKOWANIA ####

zip_unpack(){
	if [ -z "$HASLO" ]; then
		eval "unzip $SCIEZKA_ZRODLOWA.zip -d $SCIEZKA_DOCELOWA/"
	else
		eval "unzip -P $HASLO $SCIEZKA_ZRODLOWA.zip -d $SCIEZKA_DOCELOWA/"
	fi
}

rozpakowanie_zip(){
	podaj_haslo
	OKNO=`dialog --stdout --title $TYTUL --yesno "Czy podane dane się zgadzają?\n\nŚcieżka źródłowa: $SCIEZKA_ZRODLOWA\nŚcieżka docelowa: $SCIEZKA_DOCELOWA\nHasło*:$HASLO\nTyp archiwizacji: .zip\n*haslo potrzebne jedynie przy zabezpieczonych archiwach" 12 60`
	PRZYCISK=$?
	case $PRZYCISK in
		$PRZYCISK_YES)
			zip_unpack;;
		$PRZYCISK_NO)
			rozpakowanie;;
	esac
}

tar_unpack(){
	eval "tar -xvf $SCIEZKA_ZRODLOWA.tar -C $SCIEZKA_DOCELOWA/"
}

rozpakowanie_tar(){
	OKNO=`dialog --stdout --title $TYTUL --yesno "Czy podane dane się zgadzają?\n\nŚcieżka źródłowa: $SCIEZKA_ZRODLOWA\nŚcieżka docelowa: $SCIEZKA_DOCELOWA\nTyp archiwizacji: .tar" 12 60`
	PRZYCISK=$?
	case $PRZYCISK in
		$PRZYCISK_YES)
			tar_unpack;;
		$PRZYCISK_NO)
			rozpakowanie;;
	esac
}

tar_gz_unpack(){
	eval "tar -zxvf $SCIEZKA_ZRODLOWA.tar.gz -C $SCIEZKA_DOCELOWA/"
}

rozpakowanie_tar_gz(){
	OKNO=`dialog --stdout --title $TYTUL --yesno "Czy podane dane się zgadzają?\n\nŚcieżka źródłowa: $SCIEZKA_ZRODLOWA\nŚcieżka docelowa: $SCIEZKA_DOCELOWA\nTyp archiwizacji: .tar.gz" 12 60`
	PRZYCISK=$?
	case $PRZYCISK in
		$PRZYCISK_YES)
			tar_gz_unpack;;
		$PRZYCISK_NO)
			rozpakowanie;;
	esac
}

tar_bz2_unpack(){
	eval "tar -jxvf $SCIEZKA_ZRODLOWA.tar.bz2 -C $SCIEZKA_DOCELOWA/"
}

rozpakowanie_tar_bz2(){
	OKNO=`dialog --stdout --title $TYTUL --yesno "Czy podane dane się zgadzają?\n\nŚcieżka źródłowa: $SCIEZKA_ZRODLOWA\nŚcieżka docelowa: $SCIEZKA_DOCELOWA\nTyp archiwizacji: .tar.bz2" 12 60`
	PRZYCISK=$?
	case $PRZYCISK in
		$PRZYCISK_YES)
			tar_bz2_unpack;;
		$PRZYCISK_NO)
			rozpakowanie;;
	esac
}

rar_unpack(){
	if [ -z "$HASLO" ]; then
		eval "unrar x $SCIEZKA_ZRODLOWA.rar $SCIEZKA_DOCELOWA/"
	else
		eval "unrar x -p$HASLO $SCIEZKA_ZRODLOWA.rar $SCIEZKA_DOCELOWA/"
	fi
}

rozpakowanie_rar(){
	podaj_haslo
	OKNO=`dialog --stdout --title $TYTUL --yesno "Czy podane dane się zgadzają?\n\nŚcieżka źródłowa: $SCIEZKA_ZRODLOWA\nŚcieżka docelowa: $SCIEZKA_DOCELOWA\nHasło*:$HASLO\nTyp archiwizacji: .rar\n*haslo potrzebne jedynie przy zabezpieczonych archiwach" 12 60`
	PRZYCISK=$?
	case $PRZYCISK in
		$PRZYCISK_YES)
			rar_unpack;;
		$PRZYCISK_NO)
			rozpakowanie;;
	esac
}

rozpakowanie(){
	podaj_dane
	OKNO=`dialog --stdout --title $TYTUL --menu "Wybierz format archiwum:" 15 60 5 "1" ".zip" "2" ".tar" "3" ".tar.gz" "4" ".tar.bz2" "5" ".rar"`
	PRZYCISK=$?
	case $PRZYCISK in
		$PRZYCISK_CANCEL)
			start;;
		$PRZYCISK_OK)
			case $OKNO in
				1) rozpakowanie_zip;;
				2) rozpakowanie_tar;;
				3) rozpakowanie_tar_gz;;
				4) rozpakowanie_tar_bz2;;
				5) rozpakowanie_rar;;
			esac
	esac
	start
}

#### MENU GŁÓWNE DIALOGU ####
start(){
	OKNO=`dialog --stdout --title $TYTUL --menu "Wybierz jedną z dwóch opcji programu:" 10 60 5 "1" "Pakowanie" "2" "Rozpakowanie"`
	PRZYCISK=$?
	case $? in		
		$PRZYCISK_CANCEL)
			pozegnanie;;
		$PRZYCISK_OK)
			case $OKNO in
				1) pakowanie;;
				2) rozpakowanie;;
			esac
	esac
}

#### FUNKCJE ODPOWIEDZIALNE ZA OBSLUGE SKRYPTU Z POZIOMU KONSOLI ####
kompresja(){
	echo "Wybrano kompresje ROZ:$ROZSZERZENIE NAZ:$NOWA_NAZWA"
	case $ROZSZERZENIE in
		".zip") zip_pack;;
		".tar") tar_pack;;
		".tar.gz") tar_gz_pack;;
		".tar.bz2") tar_bz2_pack;;
		".rar") rar_pack;;
	esac
}

dekompresja(){
	echo "Wybrano dekompresje/n"
	case $ROZSZERZENIE in
		".zip") zip_unpack;;
		".tar") tar_unpack;;
		".tar.gz") tar_gz_unpack;;
		".tar.bz2") tar_bz2_unpack;;
		".rar") rar_unpack;;
	esac
}

####################### MAIN #######################

while getopts hqgpus:d:n:w:e: OPT; do
	case $OPT in
		h) eval "cat $SCIEZKA_FOLDERU_SKRYPTU/help.txt";;
		g) start
		   pozegnanie
		   echo `clear`;;
		p) kompresja;;
		u) dekompresja;;
		s) SCIEZKA_ZRODLOWA=$OPTARG;;
		d) SCIEZKA_DOCELOWA=$OPTARG;;
		n) NOWA_NAZWA=$OPTARG;;
  		w) HASLO=$OPTARG;;
		e) ROZSZERZENIE=$OPTARG;;
 	esac
done
