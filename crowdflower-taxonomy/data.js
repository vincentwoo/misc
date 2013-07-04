window.taxonomy_data = {
  "topLevelItems": ["1", "2", "3", "4"],

  "items": {

    "1": {
      "parent": null,
      "title": "Books",
      "children": ["11", "12", "13"]
    },
      "11": {
        "parent": "1",
        "title": "Fiction",
        "children": ["111", "112", "113"]
      },
        "111": {
          "parent": "11",
          "title": "Classic",
          "children": ["1111", "1112"]
        },
          "1111": {
            "parent": "111",
            "title": "Copyrighted"
          },
          "1112": {
            "parent": "111",
            "title": "Public Domain"
          },
        "112": {
          "parent": "11",
          "title": "Science Fiction"
        },
        "113": {
          "parent": "11",
          "title": "Thriller"
        },
      "12": {
        "parent": "1",
        "title": "Non-Fiction",
        "children": ["121", "122", "123"]
      },
        "121": {
          "parent": "12",
          "title": "How To",
          "description": "See also: 231, 122."
        },
        "122": {
          "parent": "12",
          "title": "Reference"
        },
        "123": {
          "parent": "12",
          "title": "True Crime"
        },

      "13": {
        "parent": "1",
        "title": "Other"
      },

    "2": {
      "parent": null,
      "title": "Cars",
      "children": ["21", "22", "23"]
    },
      "21": {
        "parent": "2",
        "title": "Sedans",
        "children": ["211", "212"]
      },
        "211": {
          "parent": "21",
          "title": "Accord"
        },
        "212": {
          "parent": "21",
          "title": "Camry"
        },
      "22": {
        "parent": "2",
        "title": "Trucks"
      },
      "23": {
        "parent": "2",
        "title": "Other",
        "children": ["231", "232"]
      },
        "231": {
          "parent": "21",
          "title": "Repair manuals",
          "description": "See also: 121."
        },
        "232": {
          "parent": "21",
          "title": "Tools",
          "description": "See also: 41."
        },

    "3": {
      "parent": null,
      "title": "Trains",
      "children": ["31", "32"]
    },
      "31": {
        "parent": "3",
        "title": "Big ones"
      },
      "32": {
        "parent": "3",
        "title": "Small ones"
      },

    "4": {
      "parent": null,
      "title": "Tools",
      "children": ["41", "42", "43"]
    },
      "41": {
        "parent": "4",
        "title": "Automotive",
        "children": ["411", "412", "413"]
      },
        "411": {
          "parent": "41",
          "title": "Other",
          "children": ["4111", "4112", "4113"]
        },
          "4111": {
            "parent": "411",
            "title": "Widgets",
            "children": ["41111", "41112"]
          },
            "41111": {
              "parent": "4111",
              "title": "Wamwozzles"
            },
            "41112": {
              "parent": "4111",
              "title": "Wunkles",
              "description": "Check out 41111, too."
            },
          "4112": {
            "parent": "411",
            "title": "Whatchamahoozers"
          },
          "4113": {
            "parent": "411",
            "title": "Beeps"
          },
        "412": {
          "parent": "41",
          "title": "Spanners"
        },
        "413": {
          "parent": "41",
          "title": "Wrenches"
        },
      "42": {
        "parent": "4",
        "title": "Metal"
      },
      "43": {
        "parent": "4",
        "title": "Woodworking"
      }

  }
}