import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:english_words/english_words.dart';
import 'package:provider/provider.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  int R = 0;
  int G = 0;
  int B = 0;
  double H=0;
  double S=0;
  double V=0;
  double C=0;
  double M=0;
  double Y=0;
  double K=100;
  void setCMYK(double CC,double CM, double CY, double CK) {
    C=CC;
    M=CM;
    Y=CY;
    K=CK;
    R=fromCMYKtoR(C, M, Y, K);
    G=fromCMYKtoG(C, M, Y, K);
    B=fromCMYKtoB(C, M, Y, K);
    V=fromRGBtoV(R, G, B);
    S=fromRGBtoS(R, G, B);
    if (S!=0) {
      H=fromRGBtoH(R, G, B);
    } else {
      H=0;
    }
    notifyListeners();
  }
  void setRGB(int CR, int CG,int CB) {
    R=CR;
    G=CG;
    B=CB;
    V=fromRGBtoV(R, G, B);
    S=fromRGBtoS(R, G, B);
    if (S!=0) {
      H=fromRGBtoH(R, G, B);
    } else {
      H=0;
    }
    C=fromRGBtoC(R, G, B);
    M=fromRGBtoM(R, G, B);
    Y=fromRGBtoY(R, G, B);
    K=fromRGBtoK(R, G, B);
    notifyListeners();
  }
  void setHSV(double CH,double CS, double CV) {
    H=CH;
    S=CS;
    V=CV;
    R=fromHSVtoR(H, S, V);
    B=fromHSVtoB(H, S, V);
    G=fromHSVtoG(H, S, V);
    C=fromRGBtoC(R, G, B);
    M=fromRGBtoM(R, G, B);
    Y=fromRGBtoY(R, G, B);
    K=fromRGBtoK(R, G, B);
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  MyAppState changeNotifier=MyAppState();
  Color currentColor=Colors.black;
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      themeMode: ThemeMode.light,
        home:Container(color:Colors.white, child: GridView.count(
            padding: const EdgeInsets.all(7),
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        primary: false,
        children: [
          ListenableBuilder(listenable: changeNotifier, builder: (BuildContext context, Widget? child) {
            currentColor=Color.fromRGBO(changeNotifier.R, changeNotifier.G, changeNotifier.B,1);
              return Container(color:currentColor);
          }),
          Scaffold(appBar: AppBar(title: Text("RGB color picker")),
              body:ElevatedButton(child: const Text("Show"), onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text("RGB Color picker dialog"),
                    content: ColorPicker(pickerColor: currentColor, paletteType: PaletteType.rgbWithBlue,
                        labelTypes:[ColorLabelType.rgb],onColorChanged: (Color color) {
                          changeNotifier.setRGB(color.red, color.green, color.blue);
                        }),
                    actions: <Widget>[
                      ElevatedButton(
                        child: const Text('Ok'),
                        onPressed: () {
                          setState(() => currentColor = currentColor);
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),);
              },)),
          Scaffold(appBar: AppBar(title: Text("HSV color picker")),
              body:ElevatedButton(child: const Text("Show"), onPressed: () {
            showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
              title: const Text("HSV Color picker dialog"),
              content: ColorPicker(pickerColor: currentColor, paletteType: PaletteType.hueWheel,
                  labelTypes:[ColorLabelType.hsv],onColorChanged: (Color color) {
                changeNotifier.setRGB(color.red, color.green, color.blue);
              }),
                  actions: <Widget>[
                    ElevatedButton(
                      child: const Text('Ok'),
                      onPressed: () {
                        setState(() => currentColor = currentColor);
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
            ),);
          },)),
          Scaffold(body: Widget6(changeNotifier: changeNotifier)),
          Scaffold(body: Widget4(changeNotifier: changeNotifier)),
          Scaffold(body: Widget5(changeNotifier: changeNotifier)),
          Scaffold(body: ThirdWidget(changeNotifier: changeNotifier)),
          Scaffold(body: FirstWidget(changeNotifier: changeNotifier)),
          Scaffold(body: SecondWidget(changeNotifier: changeNotifier)),

        ]
    )),
    );
  }
}

class SecondWidget extends StatefulWidget {
  const SecondWidget({super.key, required this.changeNotifier});
  final MyAppState changeNotifier;
  @override
  State<SecondWidget> createState() => _SecondWidgetState();
}
class _SecondWidgetState extends State<SecondWidget> {
  TextEditingController hCon= TextEditingController();
  TextEditingController sCon= TextEditingController();
  TextEditingController vCon= TextEditingController();
  @override
  Widget build(BuildContext context) {
    return ListView(
        padding: const EdgeInsets.all(8),
        children:<Widget> [Text("Hue"),SizedBox(
          width: 250,
          child: ListenableBuilder(listenable: widget.changeNotifier, builder: (BuildContext context, Widget? child) {
            hCon.text=widget.changeNotifier.H.round().toString();
            hCon.selection = TextSelection.fromPosition(
                TextPosition(offset: hCon.text.length));
            return TextField(
              onChanged: (text) {
                if (hCon.text.isEmpty) hCon.text="0";
                if (double.tryParse(hCon.text)!=null && double.parse(hCon.text)<=100 && int.parse(hCon.text)>=0) {
                  widget.changeNotifier.setHSV(double.parse(hCon.text), widget.changeNotifier.S, widget.changeNotifier.V);
                } else {
                  hCon.text=widget.changeNotifier.H.round().toString();
                  hCon.selection = TextSelection.fromPosition(
                      TextPosition(offset: hCon.text.length));
                }
              },
              controller: hCon,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            );
          })
        ),
          Text("Saturation"),
          SizedBox(
          width: 250,
          child: ListenableBuilder(listenable: widget.changeNotifier, builder: (BuildContext context, Widget? child) {
            sCon.text=widget.changeNotifier.S.round().toString();
            sCon.selection = TextSelection.fromPosition(
                TextPosition(offset: sCon.text.length));
            return TextField(
              onChanged: (text) {
                if (sCon.text.isEmpty) sCon.text="0";
                if (double.tryParse(sCon.text)!=null && double.parse(sCon.text)<=100 && int.parse(sCon.text)>=0) {
                  widget.changeNotifier.setHSV(widget.changeNotifier.H, double.parse(sCon.text), widget.changeNotifier.V);
                } else {
                  sCon.text=widget.changeNotifier.S.round().toString();
                  sCon.selection = TextSelection.fromPosition(
                      TextPosition(offset: sCon.text.length));
                }
              },
              controller: sCon,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            );
          })
        ),
          Text("Value"),
          SizedBox(
            width: 250,
            child: ListenableBuilder(listenable: widget.changeNotifier, builder: (BuildContext context, Widget? child) {
              vCon.text=widget.changeNotifier.V.round().toString();
              vCon.selection = TextSelection.fromPosition(
                  TextPosition(offset: vCon.text.length));
              return TextField(
                onChanged: (text) {
                  if (vCon.text.isEmpty) vCon.text="0";
                  if (double.tryParse(vCon.text)!=null && double.parse(vCon.text)<=100 && int.parse(vCon.text)>=0) {
                    widget.changeNotifier.setHSV(widget.changeNotifier.H, widget.changeNotifier.S, double.parse(vCon.text));
                  } else {
                    vCon.text=widget.changeNotifier.V.round().toString();
                    vCon.selection = TextSelection.fromPosition(
                        TextPosition(offset: vCon.text.length));
                  }
                },
                controller: vCon,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              );
            })
          ),
        ]
    );
  }
}

class FirstWidget extends StatefulWidget {
  const FirstWidget({super.key, required this.changeNotifier});
  final MyAppState changeNotifier;
  @override
  State<FirstWidget> createState() => _FirstWidgetState();
}
class _FirstWidgetState extends State<FirstWidget> {
  TextEditingController rCon= TextEditingController();
  TextEditingController gCon= TextEditingController();
  TextEditingController bCon= TextEditingController();
  @override
  Widget build(BuildContext context) {
    return ListView(
        padding: const EdgeInsets.all(8),
        children:<Widget> [Text("R"),SizedBox(
          width: 250,
          child: ListenableBuilder(listenable: widget.changeNotifier, builder: (BuildContext context, Widget? child) {
            rCon.text=widget.changeNotifier.R.toString();
            rCon.selection = TextSelection.fromPosition(
                TextPosition(offset: rCon.text.length));
            return TextField(
                  onChanged: (text) {
                    if (rCon.text.isEmpty) rCon.text="0";
                    if (int.tryParse(rCon.text)!=null && int.parse(rCon.text)<256 && int.parse(rCon.text)>-1) {
                      widget.changeNotifier.setRGB(int.parse(rCon.text),widget.changeNotifier.G , widget.changeNotifier.B);
                    } else {
                      rCon.text=widget.changeNotifier.R.toString();
                      rCon.selection = TextSelection.fromPosition(
                          TextPosition(offset: rCon.text.length));
                    }
                  },
                  controller: rCon,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                );
          })
        ),
          Text("G"),
          SizedBox(
            width: 250,
            child: ListenableBuilder(listenable: widget.changeNotifier, builder: (BuildContext context, Widget? child) {
              gCon.text=widget.changeNotifier.G.toString();
              gCon.selection = TextSelection.fromPosition(
                  TextPosition(offset: gCon.text.length));
              return TextField(
                onChanged: (text) {
                  if (gCon.text.isEmpty) gCon.text="0";
                  if (int.tryParse(gCon.text)!=null && int.parse(gCon.text)<256 && int.parse(gCon.text)>-1) {
                    widget.changeNotifier.setRGB(widget.changeNotifier.R,int.parse(gCon.text) , widget.changeNotifier.B);
                  } else {
                    gCon.text=widget.changeNotifier.G.toString();
                    gCon.selection = TextSelection.fromPosition(
                        TextPosition(offset: gCon.text.length));
                  }
                },
                controller: gCon,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              );
            })
          ),
          Text("B"),
          SizedBox(
            width: 250,
            child: ListenableBuilder(listenable: widget.changeNotifier, builder: (BuildContext context, Widget? child) {
              bCon.text=widget.changeNotifier.B.toString();
              bCon.selection = TextSelection.fromPosition(
                  TextPosition(offset: bCon.text.length));
              return TextField(
                onChanged: (text) {
                  if (bCon.text.isEmpty) bCon.text="0";
                  if (int.tryParse(bCon.text)!=null && int.parse(bCon.text)<256 && int.parse(bCon.text)>-1) {
                    widget.changeNotifier.setRGB(widget.changeNotifier.R,widget.changeNotifier.G , int.parse(bCon.text));
                  } else {
                    bCon.text=widget.changeNotifier.B.toString();
                    bCon.selection = TextSelection.fromPosition(
                        TextPosition(offset: bCon.text.length));
                  }
                },
                controller: bCon,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              );
            })
          ),

        ]
    );
  }
}

class ThirdWidget extends StatefulWidget {
  const ThirdWidget({super.key, required this.changeNotifier});
  final MyAppState changeNotifier;
  @override
  State<ThirdWidget> createState() => _ThirdWidgetState();
}
class _ThirdWidgetState extends State<ThirdWidget> {
  TextEditingController cCon = TextEditingController();
  TextEditingController mCon = TextEditingController();
  TextEditingController yCon = TextEditingController();
  TextEditingController kCon = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return ListView(
        padding: const EdgeInsets.all(8),
        children:<Widget> [Text("C"),SizedBox(
        width: 250,
        child: ListenableBuilder(listenable: widget.changeNotifier, builder: (BuildContext context, Widget? child) {
          cCon.text=widget.changeNotifier.C.round().toString();
          cCon.selection = TextSelection.fromPosition(
              TextPosition(offset: cCon.text.length));
          return TextField(
            onChanged: (text) {
              if (cCon.text.isEmpty) cCon.text="0";
              if (double.tryParse(cCon.text)!=null && double.parse(cCon.text)<=100 && double.parse(cCon.text)>=0) {
                widget.changeNotifier.setCMYK(double.parse(cCon.text), widget.changeNotifier.M, widget.changeNotifier.Y, widget.changeNotifier.K);
              } else {
                cCon.text=widget.changeNotifier.C.round().toString();
                cCon.selection = TextSelection.fromPosition(
                    TextPosition(offset: cCon.text.length));
              }
            },
            controller: cCon,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
          );
        })
    ),
          Text("M"), SizedBox(
            width: 250,
            child: ListenableBuilder(listenable: widget.changeNotifier, builder: (BuildContext context, Widget? child) {
              mCon.text=widget.changeNotifier.M.round().toString();
              mCon.selection = TextSelection.fromPosition(
                  TextPosition(offset: mCon.text.length));
              return TextField(
                onChanged: (text) {
                  if (mCon.text.isEmpty) mCon.text="0";
                  if (double.tryParse(mCon.text)!=null && double.parse(mCon.text)<=100 && double.parse(mCon.text)>=0) {
                    widget.changeNotifier.setCMYK(widget.changeNotifier.C, double.parse(mCon.text), widget.changeNotifier.Y, widget.changeNotifier.K);
                  } else {
                    mCon.text=widget.changeNotifier.M.round().toString();
                    mCon.selection = TextSelection.fromPosition(
                        TextPosition(offset: mCon.text.length));
                  }
                },
                controller: mCon,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              );
            })
        ),
          Text("Y"),SizedBox(
              width: 250,
              child: ListenableBuilder(listenable: widget.changeNotifier, builder: (BuildContext context, Widget? child) {
                yCon.text=widget.changeNotifier.Y.round().toString();
                yCon.selection = TextSelection.fromPosition(
                    TextPosition(offset: yCon.text.length));
                return TextField(
                  onChanged: (text) {
                    if (yCon.text.isEmpty) yCon.text="0";
                    if (double.tryParse(yCon.text)!=null && double.parse(yCon.text)<=100 && double.parse(yCon.text)>=0) {
                      widget.changeNotifier.setCMYK(widget.changeNotifier.C, widget.changeNotifier.M, double.parse(yCon.text), widget.changeNotifier.K);
                    } else {
                      yCon.text=widget.changeNotifier.Y.round().toString();
                      yCon.selection = TextSelection.fromPosition(
                          TextPosition(offset: yCon.text.length));
                    }
                  },
                  controller: yCon,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                );
              })
          ),
          Text("K"),SizedBox(
              width: 250,
              child: ListenableBuilder(listenable: widget.changeNotifier, builder: (BuildContext context, Widget? child) {
                kCon.text=widget.changeNotifier.K.round().toString();
                kCon.selection = TextSelection.fromPosition(
                    TextPosition(offset: kCon.text.length));
                return TextField(
                  onChanged: (text) {
                    if (kCon.text.isEmpty) kCon.text="0";
                    if (double.tryParse(kCon.text)!=null && double.parse(kCon.text)<=100 && double.parse(kCon.text)>=0) {
                      widget.changeNotifier.setCMYK(widget.changeNotifier.C, widget.changeNotifier.M, widget.changeNotifier.Y, double.parse(kCon.text));
                    } else {
                      kCon.text=widget.changeNotifier.K.round().toString();
                      kCon.selection = TextSelection.fromPosition(
                          TextPosition(offset: kCon.text.length));
                    }
                  },
                  controller: kCon,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                );
              })
          ),
        ]
    );
}}

class Widget4 extends StatefulWidget {
  const Widget4({super.key, required this.changeNotifier});
  final MyAppState changeNotifier;
  @override
  State<Widget4> createState() => _Widget4State();
}
class _Widget4State extends State<Widget4> {
  @override
  Widget build(BuildContext context) {
    return ListView(
        padding: const EdgeInsets.all(8),
    children:<Widget> [
      Text("R"),ListenableBuilder(listenable: widget.changeNotifier, builder: (BuildContext context, Widget? child) {
      return Slider(value: widget.changeNotifier.R.toDouble(),
          max: 255,
          divisions: 255,
          label: widget.changeNotifier.R.toString(),
          onChanged: (double value) {
          widget.changeNotifier.setRGB(value.round(), widget.changeNotifier.G, widget.changeNotifier.B);
          });
    }),
      Text("G"),ListenableBuilder(listenable: widget.changeNotifier, builder: (BuildContext context, Widget? child) {
        return Slider(value: widget.changeNotifier.G.toDouble(),
            max: 255,
            divisions: 255,
            label: widget.changeNotifier.G.toString(),
            onChanged: (double value) {
              widget.changeNotifier.setRGB(widget.changeNotifier.R, value.round(), widget.changeNotifier.B);
            });
      }),
      Text("B"),ListenableBuilder(listenable: widget.changeNotifier, builder: (BuildContext context, Widget? child) {
        return Slider(value: widget.changeNotifier.B.toDouble(),
            max: 255,
            divisions: 255,
            label: widget.changeNotifier.B.toString(),
            onChanged: (double value) {
              widget.changeNotifier.setRGB(widget.changeNotifier.R, widget.changeNotifier.G, value.round());
            });
      }),
    ]
    );
  }
}
class Widget5 extends StatefulWidget {
  const Widget5({super.key, required this.changeNotifier});
  final MyAppState changeNotifier;
  @override
  State<Widget5> createState() => _Widget5State();
}
class _Widget5State extends State<Widget5> {
  @override
  Widget build(BuildContext context) {
    return ListView(
        padding: const EdgeInsets.all(8),
        children:<Widget> [
          Text("Hue"),ListenableBuilder(listenable: widget.changeNotifier, builder: (BuildContext context, Widget? child) {
            return Slider(value: widget.changeNotifier.H,
                max: 100,
                divisions: 100,
                label: widget.changeNotifier.H.round().toString(),
                onChanged: (double value) {
                  widget.changeNotifier.setHSV(value, widget.changeNotifier.S, widget.changeNotifier.V);
                });
          }),
          Text("Saturation"),ListenableBuilder(listenable: widget.changeNotifier, builder: (BuildContext context, Widget? child) {
            return Slider(value: widget.changeNotifier.S,
                max: 100,
                divisions: 100,
                label: widget.changeNotifier.S.round().toString(),
                onChanged: (double value) {
                  widget.changeNotifier.setHSV(widget.changeNotifier.H, value, widget.changeNotifier.V);
                });
          }),
          Text("Value"),ListenableBuilder(listenable: widget.changeNotifier, builder: (BuildContext context, Widget? child) {
            return Slider(value: widget.changeNotifier.V,
                max: 100,
                divisions: 100,
                label: widget.changeNotifier.V.round().toString(),
                onChanged: (double value) {
                  widget.changeNotifier.setHSV(widget.changeNotifier.H, widget.changeNotifier.S, value);
                });
          }),
        ]
    );
  }
}
class Widget6 extends StatefulWidget {
  const Widget6({super.key, required this.changeNotifier});
  final MyAppState changeNotifier;
  @override
  State<Widget6> createState() => _Widget6State();
}
class _Widget6State extends State<Widget6> {
  @override
  Widget build(BuildContext context) {
    return ListView(
        padding: const EdgeInsets.all(8),
        children:<Widget> [
          Text("C"),ListenableBuilder(listenable: widget.changeNotifier, builder: (BuildContext context, Widget? child) {
            return Slider(value: widget.changeNotifier.C,
                max: 100,
                divisions: 100,
                label: widget.changeNotifier.C.round().toString(),
                onChanged: (double value) {
                  widget.changeNotifier.setCMYK(value, widget.changeNotifier.M,
                      widget.changeNotifier.Y, widget.changeNotifier.K);
                });
          }),
          Text("M"),ListenableBuilder(listenable: widget.changeNotifier, builder: (BuildContext context, Widget? child) {
            return Slider(value: widget.changeNotifier.M,
                max: 100,
                divisions: 100,
                label: widget.changeNotifier.M.round().toString(),
                onChanged: (double value) {
                  widget.changeNotifier.setCMYK(widget.changeNotifier.C, value,
                      widget.changeNotifier.Y, widget.changeNotifier.K);
                });
          }),
          Text("Y"),ListenableBuilder(listenable: widget.changeNotifier, builder: (BuildContext context, Widget? child) {
            return Slider(value: widget.changeNotifier.Y,
                max: 100,
                divisions: 100,
                label: widget.changeNotifier.Y.round().toString(),
                onChanged: (double value) {
                  widget.changeNotifier.setCMYK(widget.changeNotifier.C, widget.changeNotifier.M,
                      value, widget.changeNotifier.K);
                });
          }),
          Text("K"),ListenableBuilder(listenable: widget.changeNotifier, builder: (BuildContext context, Widget? child) {
            return Slider(value: widget.changeNotifier.K,
                max: 100,
                divisions: 100,
                label: widget.changeNotifier.K.round().toString(),
                onChanged: (double value) {
                  widget.changeNotifier.setCMYK(widget.changeNotifier.C, widget.changeNotifier.M,
                      widget.changeNotifier.Y, value);
                });
          }),
        ]
    );
  }
}
double fromRGBtoH(int R, int G, int B) {
  int tempMax=max(max(R,G),B);
  int tempMin=min(min(R,G),B);
  if (tempMax==R && G>=B) {
    return 60.0*(G-B)/(tempMax-tempMin)/360*100;
  } else if (tempMax==R && G<B) {
    return (60.0*(G-B)/(tempMax-tempMin)+360)/360*100;
  } else if (tempMax==G) {
    return (60.0*(B-R)/(tempMax-tempMin)+120)/360*100;
  } else {
    return (60.0*(R-G)/(tempMax-tempMin)+240)/360*100;
  }
}
double fromRGBtoS(int R, int G, int B) {
  if (R==0 && G==0 && B==0) {
    return 0;
  }
  return (max(max(R,G),B)-min(min(R,G),B)*1.0)/max(max(R,G),B)*100;
}
double fromRGBtoV(int R, int G, int B) {
  return max(R,max(G,B))/255.0*100;
}
int fromHSVtoR(double H, double S, double V) {
  double C=S/100*V/100;
  double Ht=H/100*360;
  double X = C*(1-((Ht/60)%2-1).abs());
  double m=V/100-C;
  if (Ht<60) {
    return ((C+m)*255).round();
  } else if (Ht<120) {
    return ((X+m)*255).round();
  } else if (Ht<180) {
    return ((0+m)*255).round();
  } else if (Ht<240) {
    return ((0+m)*255).round();
  } else if (Ht<300) {
    return ((X+m)*255).round();
  } else {
    return ((C+m)*255).round();
  }
}
int fromHSVtoB(double H, double S, double V) {
  double C=S/100*V/100;
  double Ht=H/100*360;
  double X = C*(1-((Ht/60)%2-1).abs());
  double m=V/100-C;
  if (Ht<60) {
    return ((0+m)*255).round();
  } else if (Ht<120) {
    return ((0+m)*255).round();
  } else if (Ht<180) {
    return ((X+m)*255).round();
  } else if (Ht<240) {
    return ((C+m)*255).round();
  } else if (Ht<300) {
    return ((C+m)*255).round();
  } else {
    return ((X+m)*255).round();
  }
}
int fromHSVtoG(double H, double S, double V) {
  double C=S/100*V/100;
  double Ht=H/100*360;
  double X = C*(1-((Ht/60)%2-1).abs());
  double m=V/100-C;
  if (Ht<60) {
    return ((X+m)*255).round();
  } else if (Ht<120) {
    return ((C+m)*255).round();
  } else if (Ht<180) {
    return ((C+m)*255).round();
  } else if (Ht<240) {
    return ((X+m)*255).round();
  } else if (Ht<300) {
    return ((0+m)*255).round();
  } else {
    return ((0+m)*255).round();
  }
}
double fromRGBtoK(int R,int G,int B) {
  double Rk=R/255.0;
  double Gk=G/255.0;
  double Bk=B/255.0;
  double K=1-max(Rk,max(Gk,Bk));
  return K*100;
}
double fromRGBtoC(int R,int G,int B) {
  double Rk=R/255.0;
  double Gk=G/255.0;
  double Bk=B/255.0;
  double K=1-max(Rk,max(Gk,Bk));
  if (K==1) return 0;
  return (1-Rk-K)/(1-K)*100;
}
double fromRGBtoM(int R,int G,int B) {
  double Rk=R/255.0;
  double Gk=G/255.0;
  double Bk=B/255.0;
  double K=1-max(Rk,max(Gk,Bk));
  if (K==1) return 0;
  return (1-Gk-K)/(1-K)*100;
}
double fromRGBtoY(int R,int G,int B) {
  double Rk=R/255.0;
  double Gk=G/255.0;
  double Bk=B/255.0;
  double K=1-max(Rk,max(Gk,Bk));
  if (K==1) return 0;
  return (1-Bk-K)/(1-K)*100;
}
int fromCMYKtoR(double C, double M, double Y, double K) {
  return ((1-C/100)*(1-K/100)*255).round();
}
int fromCMYKtoG(double C, double M, double Y, double K) {
  return ((1-M/100)*(1-K/100)*255).round();
}
int fromCMYKtoB(double C, double M, double Y, double K) {
  return ((1-Y/100)*(1-K/100)*255).round();
}