#include <iostream>
#include <ceres/ceres.h>

struct Functor { 
  template <typename T>
  bool operator()(const T *const x, const T *const y, T *res) const {
    res[0] = x[0];
    for (int i = 0; i < 5; ++i)
      res[0] = T(0.5) * (res[0] + x[0] / res[0]);
    res[0] -= T(1.41);

    res[1] = T(0.333) * (y[0] - T(2));
    return true;
  }
};

int main() {
  double xmin = 3, ymin = 3;
  ceres::Solver::Options options;
  ceres::Solver::Summary summary;
  ceres::Problem problem;
  auto costFunc =
      new ceres::AutoDiffCostFunction<Functor, 2, 1, 1>(new Functor);
  problem.AddResidualBlock(costFunc, nullptr, &xmin, &ymin);
  ceres::Solve(options, &problem, &summary);
  std::cout << xmin << ' ' << ymin << std::endl; //outputs `1.98 2`
  return 0;
}
