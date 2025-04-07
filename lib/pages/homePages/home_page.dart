import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rem_app/colors.dart';
import 'package:rem_app/dimensions.dart';
import 'package:rem_app/models/matrix_model.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{
  final colors = AppColors();
  final dimensions = Dimensions();

  int _selectedTag = 0;
  int get selectedTag => _selectedTag;
  set selectedTag(int value){
    setState(() {
      _selectedTag = value;
    });
  }

  int _selectedAllTag = 0;
  int get selectedAllTag => _selectedAllTag;
  set selectedAllTag(int value){
    setState(() {
      _selectedAllTag = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<MatrixModel>(
        builder: (context, model, child){
          return Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: SizedBox.expand(
                child: Container(
                  decoration: BoxDecoration(
                    color: colors.primaryColor,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        SizedBox(
                          height: dimensions.extremeNarrow ? 30 : 60,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              tagButton("Input", 0),
                              SizedBox(width: 5,),
                              tagButton("Output", 1),
                            ],
                          ),
                        ),
                        Expanded(
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              Map<String, bool> values = selectedTag == 0 ? model.inputMute : model.outputMute;
                              Widget content = Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: List.generate(4, (rowIndex) {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: List.generate(4, (colIndex) {
                                      return ShadButton.outline(
                                        onTapUp: (_) => {
                                          model.toggleMuteChannel(rowIndex * 4 + colIndex + 1, selectedTag == 0 ? "input" : "output", !(values["${rowIndex * 4 + colIndex + 1}"] ?? true))
                                        },
                                        hoverBackgroundColor: Colors.transparent,
                                        width: 60,
                                        height: 50,
                                        padding: EdgeInsets.all(0),
                                        decoration: ShadDecoration(
                                          border: ShadBorder.all(
                                            color: (values["${rowIndex * 4 + colIndex + 1}"] ?? true) 
                                              ? colors.mutedChannel 
                                              : colors.unmutedChannel, 
                                            radius: BorderRadius.circular(10),
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            'CH${rowIndex * 4 + colIndex + 1}',
                                            style: TextStyle(
                                              color: (values["${rowIndex * 4 + colIndex + 1}"] ?? true) 
                                                ? colors.mutedChannel 
                                                : colors.unmutedChannel, 
                                              fontSize: 17,
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                                  );
                                }),
                              );

                              return dimensions.extremeNarrow
                                  ? SingleChildScrollView(child: content)
                                  : content;
                            },
                          ),
                        ),
                        SizedBox(
                          height: dimensions.extremeNarrow ? 30 : 60,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              allToggleButton(model.toggleMuteChannel),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          );
        },
      )
    );
  }

  ShadButton tagButton(String title, int selection) {
    return ShadButton.outline(
      width: 80,
      height: 30,
      padding: EdgeInsets.all(0),
      decoration: ShadDecoration(
        border: ShadBorder.all(width: 2, color: selectedTag == selection ? colors.selectionColor : Colors.white, radius: BorderRadius.circular(50))
      ),
      hoverBackgroundColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      foregroundColor: selectedTag == selection ? colors.selectionColor : Colors.white,
      hoverForegroundColor: selectedTag == selection ? colors.selectionColor : Colors.white,
      child: Text(title, style: TextStyle(fontSize: 17),), 
      onTapUp: (_){
        selectedTag = selection;
      },
    );
  }

  ShadButton allToggleButton(Function function) {
    return ShadButton.outline(
      width: 110,
      height: 30,
      padding: EdgeInsets.all(0),
      decoration: ShadDecoration(
        border: ShadBorder.all(width: 2, color: selectedAllTag == 0 ? colors.mutedChannel : colors.unmutedChannel, radius: BorderRadius.circular(50))
      ),
      hoverBackgroundColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      foregroundColor: selectedAllTag == 0 ? colors.mutedChannel : colors.unmutedChannel,
      hoverForegroundColor: selectedAllTag == 0 ? colors.mutedChannel : colors.unmutedChannel,
      child: Text(selectedAllTag == 0 ? "Mute All" : "Unmute All", style: TextStyle(fontSize: 17),), 
      onTapUp: (_){
        for(int i = 1; i <= 16; i++){
          function(i, selectedTag == 0 ? "input" : "output", selectedAllTag == 0);
        }
        selectedAllTag = (selectedAllTag == 0 ? 1 : 0); 
      },
    );
  }

}