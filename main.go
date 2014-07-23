package main

import (
	"html/template"
	"log"
	"net/http"

	"github.com/GeertJohan/go.rice"
	"github.com/zenazn/goji"
	"github.com/zenazn/goji/web"
)

const publicPath = "/public/"

var (
	publicBox   = rice.MustFindBox("public")
	templateBox = rice.MustFindBox("template")
	templates   = make(map[string]*template.Template)
)

type templateItem struct {
	name string
	path string
}

func initTemplates() {
	str, err := templateBox.String("layout.tmpl")
	if err != nil {
		log.Fatal(err)
	}
	layoutTemplate, err := template.New("layout").Parse(str)

	ts := []templateItem{
		templateItem{"index", "index.tmpl"},
	}
	for _, t := range ts {
		str, err := templateBox.String(t.path)
		if err != nil {
			log.Fatal(err)
		}
		tmpl, err := layoutTemplate.Parse(str)
		if err != nil {
			log.Fatal(err)
		}
		templates[t.name] = tmpl
	}
}

func index(c web.C, w http.ResponseWriter, r *http.Request) {
	templates["index"].Execute(w, nil)
}

func main() {
	initTemplates()
	goji.Get(publicPath+"*", http.StripPrefix(publicPath, http.FileServer(publicBox.HTTPBox())))
	goji.Get("/", index)
	goji.Serve()
}
