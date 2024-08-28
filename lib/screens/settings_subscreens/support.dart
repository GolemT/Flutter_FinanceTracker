import 'package:easy_url_launcher/easy_url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:finance_tracker/assets/color_palette.dart';
import 'package:finance_tracker/components/localisations.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final nexusColor = NexusColor();

    return Scaffold(
      appBar: AppBar(
        title: Text('Support/FAQ', style: TextStyle(color: nexusColor.text)),
        backgroundColor: nexusColor.navigation,
        iconTheme: IconThemeData(color: nexusColor.text),
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: nexusColor.background,
      body: ListView(children: [
        Container(
          decoration: BoxDecoration(
            color: nexusColor.background,
            border: Border(
              bottom: BorderSide(
                color: nexusColor.inputs,
                style: BorderStyle.solid,
                strokeAlign: BorderSide.strokeAlignInside,
              ),
            ),
          ),
          child: ExpansionTile(
            iconColor: nexusColor.text,
            collapsedIconColor: nexusColor.text,
            title: Text(
              AppLocalizations.of(context).translate('usingApp'),
              style: TextStyle(color: nexusColor.text, fontSize: 18.0),
            ),
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: nexusColor.listBackground,
                  border: Border(
                      bottom: BorderSide(
                        color: nexusColor.inputs,
                        style: BorderStyle.solid,
                        strokeAlign: BorderSide.strokeAlignInside,
                      ),
                      top: BorderSide(
                        color: nexusColor.inputs,
                        style: BorderStyle.solid,
                        strokeAlign: BorderSide.strokeAlignInside,
                      )),
                ),
                child: ExpansionTile(
                  iconColor: nexusColor.text,
                  collapsedIconColor: nexusColor.text,
                  title: Text(
                    AppLocalizations.of(context).translate('questionOne'),
                    style: TextStyle(color: nexusColor.text, fontSize: 18.0),
                  ),
                  children: <Widget>[
                    Container(
                      color: nexusColor.listBackground,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              AppLocalizations.of(context)
                                  .translate('answerOne'),
                              style: TextStyle(color: nexusColor.text),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: nexusColor.listBackground,
                  border: Border(
                    bottom: BorderSide(
                      color: nexusColor.inputs,
                      style: BorderStyle.solid,
                      strokeAlign: BorderSide.strokeAlignInside,
                    ),
                  ),
                ),
                child: ExpansionTile(
                  iconColor: nexusColor.text,
                  collapsedIconColor: nexusColor.text,
                  title: Text(
                    AppLocalizations.of(context).translate('questionTwo'),
                    style: TextStyle(color: nexusColor.text, fontSize: 18.0),
                  ),
                  children: <Widget>[
                    Container(
                      color: nexusColor.listBackground,
                      child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                    AppLocalizations.of(context)
                                        .translate('answerTwo'),
                                    style: TextStyle(color: nexusColor.text))
                              ])),
                    )
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: nexusColor.listBackground,
                  border: Border(
                    bottom: BorderSide(
                      color: nexusColor.inputs,
                      style: BorderStyle.solid,
                      strokeAlign: BorderSide.strokeAlignInside,
                    ),
                  ),
                ),
                child: ExpansionTile(
                  iconColor: nexusColor.text,
                  collapsedIconColor: nexusColor.text,
                  title: Text(
                    AppLocalizations.of(context).translate('questionThree'),
                    style: TextStyle(color: nexusColor.text, fontSize: 18.0),
                  ),
                  children: <Widget>[
                    Container(
                      color: nexusColor.listBackground,
                      child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                    AppLocalizations.of(context)
                                        .translate('answerThree'),
                                    style: TextStyle(color: nexusColor.text))
                              ])),
                    )
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: nexusColor.listBackground,
                  border: Border(
                    bottom: BorderSide(
                      color: nexusColor.inputs,
                      style: BorderStyle.solid,
                      strokeAlign: BorderSide.strokeAlignInside,
                    ),
                  ),
                ),
                child: ExpansionTile(
                  iconColor: nexusColor.text,
                  collapsedIconColor: nexusColor.text,
                  title: Text(
                    AppLocalizations.of(context).translate('questionFour'),
                    style: TextStyle(color: nexusColor.text, fontSize: 18.0),
                  ),
                  children: <Widget>[
                    Container(
                      color: nexusColor.listBackground,
                      child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                    AppLocalizations.of(context)
                                        .translate('answerFour'),
                                    style: TextStyle(color: nexusColor.text))
                              ])),
                    )
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: nexusColor.listBackground,
                  border: Border(
                    bottom: BorderSide(
                      color: nexusColor.inputs,
                      style: BorderStyle.solid,
                      strokeAlign: BorderSide.strokeAlignInside,
                    ),
                  ),
                ),
                child: ExpansionTile(
                  iconColor: nexusColor.text,
                  collapsedIconColor: nexusColor.text,
                  title: Text(
                    AppLocalizations.of(context).translate('questionFive'),
                    style: TextStyle(color: nexusColor.text, fontSize: 18.0),
                  ),
                  children: <Widget>[
                    Container(
                      color: nexusColor.listBackground,
                      child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                    AppLocalizations.of(context)
                                        .translate('answerFive'),
                                    style: TextStyle(color: nexusColor.text))
                              ])),
                    )
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: nexusColor.listBackground,
                  border: Border(
                    bottom: BorderSide(
                      color: nexusColor.inputs,
                      style: BorderStyle.solid,
                      strokeAlign: BorderSide.strokeAlignInside,
                    ),
                  ),
                ),
                child: ExpansionTile(
                  iconColor: nexusColor.text,
                  collapsedIconColor: nexusColor.text,
                  title: Text(
                    AppLocalizations.of(context).translate('questionSix'),
                    style: TextStyle(color: nexusColor.text, fontSize: 18.0),
                  ),
                  children: <Widget>[
                    Container(
                      color: nexusColor.listBackground,
                      child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                    AppLocalizations.of(context)
                                        .translate('answerSix'),
                                    style: TextStyle(color: nexusColor.text))
                              ])),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: nexusColor.background,
            border: Border(
              bottom: BorderSide(
                color: nexusColor.inputs,
                style: BorderStyle.solid,
                strokeAlign: BorderSide.strokeAlignInside,
              ),
            ),
          ),
          child: ExpansionTile(
            iconColor: nexusColor.text,
            collapsedIconColor: nexusColor.text,
            title: Text(
              AppLocalizations.of(context).translate('questionSeven'),
              style: TextStyle(color: nexusColor.text, fontSize: 18.0),
            ),
            children: <Widget>[
              Container(
                color: nexusColor.background,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        AppLocalizations.of(context).translate('answerSeven'),
                        style: TextStyle(color: nexusColor.text),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: nexusColor.background,
            border: Border(
              bottom: BorderSide(
                color: nexusColor.inputs,
                style: BorderStyle.solid,
                strokeAlign: BorderSide.strokeAlignInside,
              ),
            ),
          ),
          child: ExpansionTile(
              iconColor: nexusColor.text,
              collapsedIconColor: nexusColor.text,
              title: Text(
                AppLocalizations.of(context).translate('dataStorage'),
                style: TextStyle(color: nexusColor.text, fontSize: 18.0),
              ),
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: nexusColor.listBackground,
                    border: Border(
                        bottom: BorderSide(
                          color: nexusColor.inputs,
                          style: BorderStyle.solid,
                          strokeAlign: BorderSide.strokeAlignInside,
                        ),
                        top: BorderSide(
                          color: nexusColor.inputs,
                          style: BorderStyle.solid,
                          strokeAlign: BorderSide.strokeAlignInside,
                        )),
                  ),
                  child: ExpansionTile(
                    iconColor: nexusColor.text,
                    collapsedIconColor: nexusColor.text,
                    title: Text(
                      AppLocalizations.of(context).translate('questionEight'),
                      style: TextStyle(color: nexusColor.text, fontSize: 18.0),
                    ),
                    children: <Widget>[
                      Container(
                        color: nexusColor.listBackground,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                AppLocalizations.of(context)
                                    .translate('answerEight'),
                                style: TextStyle(color: nexusColor.text),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: nexusColor.listBackground,
                    border: Border(
                      bottom: BorderSide(
                        color: nexusColor.inputs,
                        style: BorderStyle.solid,
                        strokeAlign: BorderSide.strokeAlignInside,
                      ),
                    ),
                  ),
                  child: ExpansionTile(
                    iconColor: nexusColor.text,
                    collapsedIconColor: nexusColor.text,
                    title: Text(
                      AppLocalizations.of(context).translate('questionNine'),
                      style: TextStyle(color: nexusColor.text, fontSize: 18.0),
                    ),
                    children: <Widget>[
                      Container(
                        color: nexusColor.listBackground,
                        child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                      AppLocalizations.of(context)
                                          .translate('answerNine'),
                                      style: TextStyle(color: nexusColor.text))
                                ])),
                      )
                    ],
                  ),
                ),
              ]),
        ),
        Container(
          decoration: BoxDecoration(
            color: nexusColor.background,
            border: Border(
              bottom: BorderSide(
                color: nexusColor.inputs,
                style: BorderStyle.solid,
                strokeAlign: BorderSide.strokeAlignInside,
              ),
            ),
          ),
          child: ExpansionTile(
              iconColor: nexusColor.text,
              collapsedIconColor: nexusColor.text,
              title: Text(
                AppLocalizations.of(context).translate('dataDeletion'),
                style: TextStyle(color: nexusColor.text, fontSize: 18.0),
              ),
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: nexusColor.listBackground,
                    border: Border(
                      bottom: BorderSide(
                        color: nexusColor.inputs,
                        style: BorderStyle.solid,
                        strokeAlign: BorderSide.strokeAlignInside,
                      ),
                      top: BorderSide(
                      color: nexusColor.inputs,
                      style: BorderStyle.solid,
                      strokeAlign: BorderSide.strokeAlignInside,
                    )
                    ),
                  ),
                  child: ExpansionTile(
                    iconColor: nexusColor.text,
                    collapsedIconColor: nexusColor.text,
                    title: Text(
                      AppLocalizations.of(context).translate('questionTen'),
                      style: TextStyle(color: nexusColor.text, fontSize: 18.0),
                    ),
                    children: <Widget>[
                      Container(
                        color: nexusColor.listBackground,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                AppLocalizations.of(context)
                                    .translate('answerTen'),
                                style: TextStyle(color: nexusColor.text),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: nexusColor.listBackground,
                    border: Border(
                      bottom: BorderSide(
                        color: nexusColor.inputs,
                        style: BorderStyle.solid,
                        strokeAlign: BorderSide.strokeAlignInside,
                      ),
                    ),
                  ),
                  child: ExpansionTile(
                    iconColor: nexusColor.text,
                    collapsedIconColor: nexusColor.text,
                    title: Text(
                      AppLocalizations.of(context).translate('questionEleven'),
                      style: TextStyle(color: nexusColor.text, fontSize: 18.0),
                    ),
                    children: <Widget>[
                      Container(
                        color: nexusColor.listBackground,
                        child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                      AppLocalizations.of(context)
                                          .translate('answerEleven'),
                                      style: TextStyle(color: nexusColor.text))
                                ])),
                      )
                    ],
                  ),
                ),
              ]),
        ),
        Container(
            decoration: BoxDecoration(
              color: nexusColor.background,
              border: Border(
                bottom: BorderSide(
                  color: nexusColor.inputs,
                  style: BorderStyle.solid,
                  strokeAlign: BorderSide.strokeAlignInside,
                ),
              ),
            ),
            child: ExpansionTile(
                iconColor: nexusColor.text,
                collapsedIconColor: nexusColor.text,
                title: Text(
                  AppLocalizations.of(context).translate('questionTwelve'),
                  style: TextStyle(color: nexusColor.text, fontSize: 18.0),
                ),
                children: <Widget>[
                  Container(
                    color: nexusColor.background,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            AppLocalizations.of(context)
                                .translate('answerTwelve'),
                            style: TextStyle(color: nexusColor.text),
                          ),
                        ],
                      ),
                    ),
                  ),
                ])),
      ]),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0), // Optional margin
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () async {
            await EasyLauncher.email(
                email: 'tkosleckmicro@gmail.com',
                subject: "Request for Support",
                body: "Hello NexusCode");
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: NexusColor.secondary,
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
          ),
          child: Text(
            AppLocalizations.of(context).translate('interaction'),
            style: TextStyle(color: nexusColor.text, fontSize: 18),
          ),
        ),
      ),
    );
  }
}
