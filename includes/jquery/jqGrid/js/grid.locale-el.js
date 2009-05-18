;(function($){
/**
 * jqGrid Greek (el) Translation
 * Alex Cicovic
 * http://www.alexcicovic.com
 * Dual licensed under the MIT and GPL licenses:
 * http://www.opensource.org/licenses/mit-license.php
 * http://www.gnu.org/licenses/gpl.html
**/
$.jgrid = {};

$.jgrid.defaults = {
	recordtext: "Εγγραφές",
	loadtext: "Φόρτωση...",
	pgtext : "/"
};
$.jgrid.search = {
    caption: "Αναζήτηση...",
    Find: "Εύρεση",
    Reset: "Επαναφορά",
    odata : ['ίσο', 'άνισο', 'μικρότερο από', 'μικρότερο ή ίσο','μεγαλύτερο από','μεγαλύτερο ή ίσο', 'ξεκινά με','τελειώνει με','εμπεριέχει' ]
};
$.jgrid.edit = {
    addCaption: "Εισαγωγή Εγγραφής",
    editCaption: "Επεξεργασία Εγγραφής",
    bSubmit: "Καταχώρηση",
    bCancel: "Άκυρο",
	bClose: "Κλείσιμο",
    processData: "Υπό επεξεργασία...",
    msg: {
        required:"Το πεδίο είναι απαραίτητο",
        number:"Το πεδίο δέχεται μόνο αριθμούς",
        minValue:"Η τιμή πρέπει να είναι μεγαλύτερη ή ίση του ",
        maxValue:"Η τιμή πρέπει να είναι μικρότερη ή ίση του ",
        email: "Η διεύθυνση e-mail δεν είναι έγκυρη",
        integer: "Το πεδίο δέχεται μόνο ακέραιους αριθμούς",
		date: "Ή ημερομηνία δεν είναι έγκυρη"
    }
};
$.jgrid.del = {
    caption: "Διαγραφή",
    msg: "Διαγραφή των επιλεγμένων εγγραφών;",
    bSubmit: "Ναι",
    bCancel: "Άκυρο",
    processData: "Υπό επεξεργασία..."
};
$.jgrid.nav = {
	edittext: " ",
    edittitle: "Επεξεργασία επιλεγμένης εγγραφής",
	addtext:" ",
    addtitle: "Εισαγωγή νέας εγγραφής",
    deltext: " ",
    deltitle: "Διαγραφή επιλεγμένης εγγραφής",
    searchtext: " ",
    searchtitle: "Εύρεση Εγγραφών",
    refreshtext: "",
    refreshtitle: "Ανανέωση Πίνακα",
    alertcap: "Προσοχή",
    alerttext: "Δεν έχετε επιλέξει εγγραφή"
};
// setcolumns module
$.jgrid.col ={
    caption: "Εμφάνιση / Απόκρυψη Στηλών",
    bSubmit: "ΟΚ",
    bCancel: "Άκυρο"
};
$.jgrid.errors = {
	errcap : "Σφάλμα",
	nourl : "Δεν έχει δοθεί διεύθυνση χειρισμού για τη συγκεκριμένη ενέργεια",
	norecords: "Δεν υπάρχουν εγγραφές προς επεξεργασία",
	model : "Άνισος αριθμός πεδίων colNames/colModel!"
};
$.jgrid.formatter = {
	integer : {thousandsSeparator: " ", defaulValue: 0},
	number : {decimalSeparator:".", thousandsSeparator: " ", decimalPlaces: 2, defaulValue: 0},
	currency : {decimalSeparator:".", thousandsSeparator: " ", decimalPlaces: 2, prefix: "", suffix:"", defaulValue: 0},
	date : {
		dayNames:   [
			"Κυρ", "Δευ", "Τρι", "Τετ", "Πεμ", "Παρ", "Σαβ",
			"Κυριακή", "Δευτέρα", "Τρίτη", "Τετάρτη", "Πέμπτη", "Παρασκευή", "Σάββατο"
		],
		monthNames: [
			"Ιαν", "Φεβ", "Μαρ", "Απρ", "Μαι", "Ιουν", "Ιουλ", "Αυγ", "Σεπ", "Οκτ", "Νοε", "Δεκ",
			"Ιανουάριος", "Φεβρουάριος", "Μάρτιος", "Απρίλιος", "Μάιος", "Ιούνιος", "Ιούλιος", "Αύγουστος", "Σεπτέμβριος", "Οκτώβριος", "Νοέμβριος", "Δεκέμβριος"
		],
		AmPm : ["πμ","μμ","ΠΜ","ΜΜ"],
		S: function (j) {return j == 1 || j > 1 ? ['η'][Math.min((j - 1) % 10, 3)] : ''},
		srcformat: 'Y-m-d',
		newformat: 'd/m/Y',
		masks : {
            ISO8601Long:"Y-m-d H:i:s",
            ISO8601Short:"Y-m-d",
            ShortDate: "n/j/Y",
            LongDate: "l, F d, Y",
            FullDateTime: "l, F d, Y g:i:s A",
            MonthDay: "F d",
            ShortTime: "g:i A",
            LongTime: "g:i:s A",
            SortableDateTime: "Y-m-d\\TH:i:s",
            UniversalSortableDateTime: "Y-m-d H:i:sO",
            YearMonth: "F, Y"
        },
        reformatAfterEdit : false
	},
	baseLinkUrl: '', // showlink
	showAction: 'show' // showlink
};
// US
// GB
// CA
// AU
})(jQuery);
