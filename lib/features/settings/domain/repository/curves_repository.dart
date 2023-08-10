
import 'package:surf_practice_magic_ball/features/settings/data_sources/curves_data_source.dart';
import 'package:surf_practice_magic_ball/features/settings/domain/entity/custom_curve.dart';

class AnimationCurveRepository {
  final curves = curvesDataSource;

  List<CustomCurve> getCurves() {
    return curves;
  }

  CustomCurve? getCurveByTitle(String title) {
    final curveByTitleList = curves.where((curve) => curve.title == title);
    if(curveByTitleList.isEmpty) return null;
    return curveByTitleList.first;
  }
}
