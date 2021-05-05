import 'package:capstone_mobile/generated/l10n.dart';
import 'package:capstone_mobile/src/blocs/violation_by_demand/violation_by_demand_bloc.dart';
import 'package:capstone_mobile/src/blocs/violation_list_create/violation_create_bloc.dart';
import 'package:capstone_mobile/src/ui/constants/constant.dart';
import 'package:capstone_mobile/src/ui/widgets/violation/dropdown_field.dart';
import 'package:capstone_mobile/src/utils/utils.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:formz/formz.dart';

import 'package:capstone_mobile/src/data/models/violation/violation.dart';
import 'package:capstone_mobile/src/data/models/regulation/regulation.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class ViolationCreateEditForm extends StatefulWidget {
  const ViolationCreateEditForm({
    Key key,
    @required this.violation,
    @required this.size,
    @required this.isEditing,
    @required this.successCallBack,
    this.bloc,
  }) : super(key: key);

  final Violation violation;
  final Size size;
  final bool isEditing;
  final Function successCallBack;
  final bloc;

  @override
  _ViolationCreateEditFormState createState() =>
      _ViolationCreateEditFormState();
}

class _ViolationCreateEditFormState extends State<ViolationCreateEditForm> {
  List<String> _imagePaths;
  List<Asset> _assets = List();
  final picker = ImagePicker();

  Future loadImages(int quantity) async {
    var result = await Utils.loadImages(quantity);

    if (!mounted) return;

    if (result.length > 0) {
      setState(() {
        _assets = result;
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    _imagePaths = widget.violation.imagePaths;
    List visibleImages = List();
    _imagePaths.forEach((element) {
      visibleImages.add(element);
    });
    _assets.forEach((element) {
      visibleImages.add(element);
    });
    return BlocListener<ViolationCreateBloc, ViolationCreateState>(
      listener: (context, state) {
        if (state.status.isSubmissionSuccess) {
          CoolAlert.show(
            context: context,
            type: CoolAlertType.success,
            text: S.of(context).VIOLATION +
                ' ' +
                S.of(context).POPUP_UPDATE_SUCCESS,
          ).then((value) {
            if (widget.bloc != null) {
              var bloc = BlocProvider.of<ViolationCreateBloc>(context);
              widget.bloc.add(ViolationByDemandUpdated(
                violation: widget.violation.copyWith(
                  name: widget.violation.name,
                  description: bloc.state.violationDescription.value,
                  regulationId: bloc.state.violationRegulation.value.id,
                  regulationName: bloc.state.violationRegulation.value.name,
                  imagePaths: _imagePaths,
                  assets: _assets,
                ),
              ));
            }

            widget.successCallBack(
              context,
            );
          });
        }
        if (state.status.isSubmissionInProgress) {
          CoolAlert.show(
            barrierDismissible: false,
            context: context,
            type: CoolAlertType.loading,
            text: S.of(context).POPUP_CREATE_VIOLATION_SUBMITTING,
          );
        }
        if (state.status.isSubmissionFailure) {
          CoolAlert.show(
            context: context,
            type: CoolAlertType.error,
            title: "Oops...",
            text:
                S.of(context).VIOLATION + ' ' + S.of(context).POPUP_UPDATE_FAIL,
          ).then((value) => Navigator.pop(context));
        }
      },
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: ListView(
            children: [
              // action button
              Container(
                child: Text(
                  '${widget.violation.name}',
                  overflow: TextOverflow.visible,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    child: Text(S.of(context).VIOLATION_STATUS + ': '),
                  ),
                  Container(
                    child: Text(
                      "${widget.violation?.status}",
                      style: TextStyle(
                          color: Constant
                              .violationStatusColors[widget.violation?.status]),
                    ),
                  ),
                ],
              ),
              Divider(
                  color:
                      Constant.violationStatusColors[widget.violation?.status]),

              // regulation dropdown
              Container(
                child: Text(
                  S.of(context).REGULATION + ':',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              DropdownFieldRegulation(
                  initValue: widget.isEditing == true
                      ? Regulation(
                          id: widget.violation.regulationId,
                          name: widget.violation.regulationName,
                        )
                      : null),
              SizedBox(
                height: 16,
              ),
              Container(
                child: Text(
                  S.of(context).DESCRIPTION + ':',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                child: _ViolationDescriptionInput(
                  initValue: widget.isEditing == true
                      ? widget.violation.description
                      : null,
                ),
              ),

              SizedBox(
                height: 16,
              ),
              Container(
                child: Text(S.of(context).EVIDENCE + ':',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              SizedBox(
                height: 16,
              ),
              visibleImages.isNotEmpty
                  ? buildGridView(visibleImages)
                  : Container(),
              SizedBox(height: 16),
              visibleImages.length < 5 || visibleImages.isEmpty
                  ? GestureDetector(
                      onTap: () {
                        loadImages(5 - _imagePaths.length);
                      },
                      child: Row(
                        children: [
                          Card(
                            elevation: 0,
                            color: Colors.grey[200],
                            child: Container(
                              height:
                                  MediaQuery.of(context).size.height * 0.175,
                              width: MediaQuery.of(context).size.width * 0.275,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add),
                                  Text(
                                    S.of(context).VIOLATION_CREATE_MODAL_ADD +
                                        ' ' +
                                        S.of(context).EVIDENCE,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(),
              SizedBox(
                height: 20.0,
              ),
              _ActionButton(
                  assets: _assets,
                  imagePaths: _imagePaths,
                  widget: widget,
                  theme: theme),
              SizedBox(
                height: 24,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildGridView(List images) {
    if (images != null) {
      return GridView.count(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        mainAxisSpacing: 10,
        crossAxisSpacing: 1,
        crossAxisCount: 3,
        children: List.generate(images.length, (index) {
          var image = images[index];
          if (image is String) {
            return Stack(
              children: [
                Container(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        color: Color(0xffF2F2F2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0.0, 1.0), //(x,y)
                            blurRadius: 6.0,
                          ),
                        ],
                      ),
                      child: Image.network(
                        image,
                        width: 100,
                        height: 120,
                      )),
                ),
                Positioned(
                  top: 0,
                  right: 5,
                  child: GestureDetector(
                    onTap: () {
                      if (image is String) {
                        setState(() {
                          images.removeAt(index);
                          _imagePaths.removeAt(index);
                        });
                      }
                    },
                    child: Container(
                      height: 24,
                      width: 24,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.red),
                      ),
                      child: Icon(
                        Icons.clear,
                        color: Colors.red,
                        size: 16.0,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
          return Stack(
            children: [
              Container(
                alignment: Alignment.bottomLeft,
                height: double.infinity,
                width: double.infinity,
                child: Container(
                  height: 100,
                  width: 100,
                  child: AssetThumb(
                    asset: image,
                    width: 80,
                    height: 120,
                  ),
                ),
              ),
              Positioned(
                top: 0,
                right: 8,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      images.removeAt(index);
                      _assets.removeAt(images.length - _imagePaths.length - 1);
                    });
                  },
                  child: Container(
                    height: 24,
                    width: 24,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.red),
                    ),
                    child: Icon(
                      Icons.clear,
                      color: Colors.red,
                      size: 16.0,
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      );
    } else
      return Container(color: Colors.white);
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    Key key,
    @required this.assets,
    @required this.imagePaths,
    @required this.widget,
    @required this.theme,
  }) : super(key: key);

  final widget;
  final ThemeData theme;
  final List<Asset> assets;
  final List<String> imagePaths;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlocBuilder<ViolationCreateBloc, ViolationCreateState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          var bloc = BlocProvider.of<ViolationCreateBloc>(context);

          return Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.3),
            child: ElevatedButton(
              onPressed: state.status.isValid &&
                      ((imagePaths.length + assets.length) > 0 &&
                              (imagePaths.length + assets.length) <= 5) !=
                          null
                  ? () {
                      bloc.add(
                        ViolationUpdated(
                          violation: widget.violation.copyWith(
                            name: widget.violation.name,
                            description: bloc.state.violationDescription.value,
                            regulationId:
                                bloc.state.violationRegulation.value.id,
                            regulationName:
                                bloc.state.violationRegulation.value.name,
                            imagePaths: imagePaths,
                            assets: assets,
                          ),
                        ),
                      );
                    }
                  : null,
              child: Text(
                  '${widget.isEditing == true ? S.of(context).SAVE : 'Add'}'),
              style: ElevatedButton.styleFrom(
                primary: theme.primaryColor,
                elevation: 5,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ViolationDescriptionInput extends StatefulWidget {
  final String initValue;

  const _ViolationDescriptionInput({Key key, this.initValue}) : super(key: key);

  @override
  __ViolationDescriptionInputState createState() =>
      __ViolationDescriptionInputState();
}

class __ViolationDescriptionInputState
    extends State<_ViolationDescriptionInput> {
  @override
  void initState() {
    super.initState();
    if (widget.initValue != null || widget.initValue != '') {
      context.read<ViolationCreateBloc>().add(
            ViolationDescriptionChanged(
              violationDescription: widget.initValue,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ViolationCreateBloc, ViolationCreateState>(
        buildWhen: (previous, current) =>
            previous.violationDescription != current.violationDescription,
        builder: (contex, state) {
          return TextFormField(
            initialValue: widget.initValue ?? '',
            key: const Key('violationForm_violationDescriptionInput_textField'),
            onChanged: (violationDescription) {
              if (violationDescription.isEmpty) {
                context.read<ViolationCreateBloc>().add(
                      ViolationDescriptionChanged(
                        violationDescription: null,
                      ),
                    );
              } else if (violationDescription.isNotEmpty) {
                context.read<ViolationCreateBloc>().add(
                      ViolationDescriptionChanged(
                        violationDescription: violationDescription,
                      ),
                    );
              }
            },
            style: TextStyle(fontSize: 14),
            decoration: InputDecoration(
              fillColor: Colors.grey[200],
              filled: true,
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              errorText: state.violationDescription.invalid
                  ? 'invalid violation description'
                  : null,
            ),
            // minLines: 5,
            minLines: 5,
            maxLines: 10,
          );
        });
  }
}
