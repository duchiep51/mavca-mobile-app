// Expanded(
//     child: Container(
//   height: 24,
//   child: TextField(
//     decoration: InputDecoration(
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(24),
//       ),
//       contentPadding: const EdgeInsets.symmetric(
//           vertical: 2.0, horizontal: 8),
//       hintText: 'Search by regulation',
//       hintStyle: TextStyle(fontSize: 12),
//       suffixIcon: Icon(Icons.search),
//     ),
//     onSubmitted: (text) {
//       BlocProvider.of<ViolationBloc>(context).add(
//         FilterChanged(
//           token: BlocProvider.of<AuthenticationBloc>(context)
//               .state
//               .token,
//           filter: (BlocProvider.of<ViolationBloc>(context).state
//                   as ViolationLoadSuccess)
//               .activeFilter
//               .copyWith(regulationId: 1),
//         ),
//       );
//     },
//   ),
// )),
// FilterButton(
//   visible: true,
// ),
