;(function($){
/**
 * jqGrid (fi) Finnish Translation
 * Jukka Inkeri  awot.fi
 * http://awot.fi
 * Dual licensed under the MIT and GPL licenses:
 * http://www.opensource.org/licenses/mit-license.php
 * http://www.gnu.org/licenses/gpl.html
**/
$.jgrid = {};

$.jgrid.defaults = {
	recordtext: "Rivej&auml;",
	loadtext: "Haetaan...",
	pgtext : "/"
};
$.jgrid.search = {
    caption: "Etsi...",
    Find: "Etsi",
    Reset: "Tyhj&auml;&auml;",
    odata : ['=', '<>', '<', '<=','>','>=', 'alkaa','loppuu','sis&auml;t&auml;&auml;' ]
};
$.jgrid.edit = {
    addCaption: "Uusi rivi",
    editCaption: "Muokkaa rivi",
    bSubmit: "OK",
    bCancel: "Peru",
	bClose: "Sulje",
    processData: "Suoritetaan...",
    msg: {
        required:"pakollinen",
        number:"Anna kelvollinen nro",
        minValue:"arvo oltava >= ",
        maxValue:"arvo oltava  <= ",
        email: "virheellinen sposti ",
        integer: "Anna kelvollinen kokonaisluku",
		date: "Anna kelvollinen pvm"
    }
};
$.jgrid.del = {
    caption: "Poista",
    msg: "Poista valitut  rivi(t)?",
    bSubmit: "Poista",
    bCancel: "Peru",
    processData: "Suoritetaan..."
};
$.jgrid.nav = {
	edittext: " ",
    edittitle: "Muokkaa valittu rivi",
	addtext:" ",
    addtitle: "Uusi rivi",
    deltext: " ",
    deltitle: "Poista valittu rivi",
    searchtext: " ",
    searchtitle: "Etsi tietoja",
    refreshtext: "",
    refreshtitle: "Lataa uudelleen",
    alertcap: "Varoitus",
    alerttext: "Valitse rivi"
};
// setcolumns module
$.jgrid.col ={
    caption: "Nayta/Piilota sarakkeet",
    bSubmit: "OK",
    bCancel: "Peru"	
};
$.jgrid.errors = {
	errcap : "Virhe",
	nourl : "url asettamatta",
	norecords: "Ei muokattavia tietoja",
    model : "Pituus colNames <> colModel!"
};
$.jgrid.formatter = {
	integer : {thousandsSeparator: "", defaulValue: 0},
	number : {decimalSeparator:",", thousandsSeparator: "", decimalPlaces: 2, defaulValue: 0},
	currency : {decimalSeparator:",", thousandsSeparator: "", decimalPlaces: 2, prefix: "", suffix:"", defaulValue: 0},
	date : {
		dayNames:   [
			"Su", "Ma", "Ti", "Ke", "To", "Pe", "La",
			"Sunnuntai", "Maanantai", "Tiista", "Keskiviikko", "Torstai", "Perjantai", "Lauantai"
		],
		monthNames: [
			"Tam", "Hel", "Maa", "Huh", "Tou", "Kes", "Hei", "Elo", "Syy", "Lok", "Mar", "Jou",
			"Tammikuu", "Helmikuu", "Maaliskuu", "Huhtikuu", "Toukokuu", "Kes&auml;kuu", "Hein&auml;kuu", "Elokuu", "Syyskuu", "Lokakuu", "Marraskuu", "Joulukuu"
		],
		AmPm : ["am","pm","AM","PM"],
		S: function (j) {return j < 11 || j > 13 ? ['st', 'nd', 'rd', 'th'][Math.min((j - 1) % 10, 3)] : 'th'},
		srcformat: 'Y-m-d',
		newformat: 'd/m/Y',
		masks : {
            ISO8601Long:"Y-m-d H:i:s",
            ISO8601Short:"Y-m-d",
            ShortDate: "d.m.Y",
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
	baseLinkUrl: '',
	showAction: 'nayta'
};
// FI
})(jQuery);
