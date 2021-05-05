import 'package:capstone_mobile/src/blocs/localization/localization_bloc.dart';
import 'package:capstone_mobile/src/blocs/violation/violation_bloc.dart';
import 'package:capstone_mobile/src/blocs/violation_list/violation_list_bloc.dart';
import 'package:capstone_mobile/src/blocs/violation_list_create/violation_create_bloc.dart';
import 'package:capstone_mobile/src/data/repositories/authentication/authentication_repository.dart';
import 'package:capstone_mobile/src/data/repositories/violation/violation_repository.dart';
import 'package:capstone_mobile/src/ui/widgets/violation/dropdown_field.dart';
import 'package:capstone_mobile/src/data/models/violation/violation.dart';
import 'package:capstone_mobile/src/data/models/regulation/regulation.dart';
import 'package:capstone_mobile/src/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:capstone_mobile/generated/l10n.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class ModalBody extends StatefulWidget {
  const ModalBody({
    Key key,
    @required this.bloc,
    @required this.size,
    this.isEditing = false,
    this.violation,
    this.position,
  }) : super(key: key);

  final ViolationListBloc bloc;
  final Size size;
  final bool isEditing;
  final Violation violation;
  final int position;

  @override
  _ModalBodyState createState() => _ModalBodyState();
}

class _ModalBodyState extends State<ModalBody> {
  List<Asset> _assets = List();

  Future loadiImages() async {
    var result = await Utils.loadImages(5 - _assets.length);

    if (!mounted) return;

    if (result.length > 0) {
      setState(() {
        _assets = _assets + result;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.isEditing) {
      _assets = widget.violation.assets;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocalizationBloc, String>(builder: (context, state) {
      return Material(
        clipBehavior: Clip.antiAlias,
        // borderRadius: BorderRadius.circular(16.0),
        child: SafeArea(
          top: false,
          child: BlocProvider(
            create: (context) => ViolationCreateBloc(
              violationBloc: BlocProvider.of<ViolationBloc>(context),
              authenticationRepository:
                  RepositoryProvider.of<AuthenticationRepository>(context),
              violationRepository: ViolationRepository(),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                height: widget.size.height * 0.8,
                child: ListView(
                  children: [
                    // action button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Text(
                              widget.isEditing
                                  ? S.of(context).EDIT_VIOLATION
                                  : S.of(context).NEW_VIOLATION,
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 24.0,
                                fontWeight: FontWeight.w600,
                              )),
                        ),
                        IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        )
                      ],
                    ),
                    Divider(
                      color: Theme.of(context).primaryColor,
                    ),
                    Container(
                      child: Text(S.of(context).REGULATION + ': ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          )),
                    ),

                    SizedBox(
                      height: 8.0,
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
                    // regulation dropdown
                    Container(
                      child: Text(
                        S.of(context).DESCRIPTION + ': ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8.0,
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
                      child: Text(
                        S.of(context).EVIDENCE + ': ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    _assets.length < 5
                        ? GestureDetector(
                            onTap: loadiImages,
                            child: Card(
                              color: Colors.grey,
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.1,
                                // width: double.infinity,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      S.of(context).ADD_IMAGE,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : Container(),
                    buildGridView(_assets),
                    SizedBox(
                      height: 16,
                    ),
                    Center(
                      child: Builder(builder: (context) {
                        return BlocBuilder<ViolationCreateBloc,
                            ViolationCreateState>(
                          buildWhen: (previous, current) =>
                              previous.status != current.status,
                          builder: (context, state) {
                            var bloc =
                                BlocProvider.of<ViolationCreateBloc>(context);
                            return ElevatedButton(
                              onPressed: bloc.state.status.isValid
                                  ? () async {
                                      var state = bloc.state;
                                      Navigator.pop<List>(
                                        context,
                                        [
                                          Violation(
                                            description: state
                                                .violationDescription.value,
                                            regulationId: state
                                                .violationRegulation.value.id,
                                            regulationName: state
                                                .violationRegulation.value.name,
                                            assets: _assets,
                                          ),
                                          widget.position,
                                        ],
                                      );
                                    }
                                  : null,
                              child: Text(
                                '${widget.isEditing == true ? S.of(context).EDIT : S.of(context).VIOLATION_CREATE_MODAL_ADD}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                elevation: 5.0,
                                primary: Theme.of(context).primaryColor,
                                padding: EdgeInsets.symmetric(horizontal: 48),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            );
                          },
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget buildGridView(images) {
    if (images.length > 0)
      return GridView.count(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        crossAxisSpacing: 2,
        crossAxisCount: 3,
        children: List.generate(images.length, (index) {
          Asset asset = images[index];
          return Stack(
            children: [
              Container(
                // color: Colors.red,
                alignment: Alignment.bottomLeft,
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: AssetThumb(
                    asset: asset,
                    width: 100,
                    height: 200,
                  ),
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _assets.removeAt(index);
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
    else
      return Container();
  }
}

class _ViolationDescriptionInput extends StatelessWidget {
  final String initValue;

  const _ViolationDescriptionInput({Key key, this.initValue}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (initValue != null) {
      BlocProvider.of<ViolationCreateBloc>(context).add(
        ViolationDescriptionChanged(
          violationDescription: initValue,
        ),
      );
    }
    return BlocBuilder<ViolationCreateBloc, ViolationCreateState>(
        buildWhen: (previous, current) =>
            previous.violationDescription != current.violationDescription,
        builder: (contex, state) {
          return TextFormField(
            initialValue: initValue ?? '',
            key: const Key('violationForm_violationDescriptionInput_textField'),
            onChanged: (violationDescription) {
              if (violationDescription.isNotEmpty) {
                context.read<ViolationCreateBloc>().add(
                      ViolationDescriptionChanged(
                        violationDescription: violationDescription,
                      ),
                    );
              } else if (violationDescription.isEmpty) {
                context.read<ViolationCreateBloc>().add(
                      ViolationDescriptionChanged(
                        violationDescription: null,
                      ),
                    );
              }
            },
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
            maxLines: 5,
          );
        });
  }
}
