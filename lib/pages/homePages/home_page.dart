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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<MatrixModel>(
        builder: (context, model, child){
          return Center(
            child: Padding(
              padding: EdgeInsets.only(top:20, left:20, right:20, bottom:10),
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
                        Divider(height: dimensions.extremeNarrow ? 2 : 10, thickness: 2, color: Colors.white,),
                        Expanded(
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              Widget content = Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: List.generate(4, (rowIndex) {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: List.generate(4, (colIndex) {
                                      return ShadButton.outline(
                                        hoverBackgroundColor: Colors.transparent,
                                        width: 60,
                                        height: 50,
                                        padding: EdgeInsets.all(0),
                                        decoration: ShadDecoration(
                                          border: ShadBorder.all(
                                            color: (model.inputMute["${rowIndex * 4 + colIndex + 1}"] ?? true) 
                                              ? colors.mutedChannel 
                                              : colors.unmutedChannel, 
                                            radius: BorderRadius.circular(10),
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            'CH${rowIndex * 4 + colIndex + 1}',
                                            style: TextStyle(
                                              color: (model.inputMute["${rowIndex * 4 + colIndex + 1}"] ?? true) 
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
                        )
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

}