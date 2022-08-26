# Bioink Printability
It is used to check printability of bioinks used in generating artificial organs.

Hello,

These codes are used to test the printability of several types of bioink while printing different structures. The details of the algorithm are published in the following paper. __You can use these codes if you cite this paper.__ The bibtex for giving a reference is given at the end of this readme file.


__Uzun-Per, M., Gillispie, G.J., Tavolara, T. E., Yoo, J.J, Atala, A., Gurcan, M.N., Lee, S.J., Niazi, M.K.K., “Automated Image Analysis Methodologies to Compute Bioink Printability”, Advanced Engineering Materials, vol: 23/4, December 2020.__

Abstract
The lack of suitable bioinks in bioprinting is a major limitation in tissue engineering and regenerative medicine. The reasons are multifaceted but can primarily be attributed to the contradictory requirements for bioinks to demonstrate desirable bioactivity while exhibiting high printability. Herein, methods are proposed and tools are provided to automatically quantitate the performance of bioinks using image analysis methods and differential geometry. Several artifact structures are used including a __crosshatch__ to evaluate filament fusion, __five-layer tube__ to evaluate stacked arc accuracy, __overhang__ to test filament collapse, and a novel __four-angled pattern__ to evaluate turn accuracy. Automatic measurements are 95.8% accurate in delineating pores of a crosshatch pattern, 96.5%, 86.0%, 80.3%, and 80.5% accuracy for each angle of a four-angled pattern, 98.9% and 97.9% accuracy for the external and internal radii of a five-layer tube, and 90.6% and 99.0% accuracy for the height and width of a five-layer tube. This automation reduces the time and effort required to analyze a structure and also provides a standardized set of tools to compare different bioinks.

By using the codes, we also wrote the following paper. You can see the bibtex at the end of this readme file. Our other paper that we used the codes to evaluate printability is not published yet.

__Gillispie, G.J., Han, A., Uzun-Per, M., Fisher, J., Mikos, A. G., Niazi M.K.K., Yoo J.J,, Lee, S.J., Atala A., “The Influence of Printing Parameters and Cell Density on Bioink Printing Outcomes”, Tissue Engineering Part A, September 2020.__


@article{uzunper2021,
  title={Automated Image Analysis Methodologies to Compute Bioink Printability},
  author={Uzun-Per, Meryem and Gillispie, Gregory J and Tavolara, Thomas Erol and Yoo, James J and Atala, Anthony and Gurcan, Metin Nafi and Lee, Sang Jin and Niazi, Muhammad Khalid Khan},
  journal={Advanced Engineering Materials},
  volume={23},
  number={4},
  pages={2000900},
  year={2021},
  publisher={Wiley Online Library}
}

@article{gillispieUzunper2020,
  title={The influence of printing parameters and cell density on bioink printing outcomes},
  author={Gillispie, Gregory J and Han, Albert and Uzun-Per, Meryem and Fisher, John and Mikos, Antonios G and Niazi, Muhammad Khalid Khan and Yoo, James J and Lee, Sang Jin and Atala, Anthony},
  journal={Tissue Engineering Part A},
  volume={26},
  number={23-24},
  pages={1349--1358},
  year={2020},
  publisher={Mary Ann Liebert, Inc., publishers 140 Huguenot Street, 3rd Floor New~…}
}

These codes are for our artifact dataset v2.1. For artifact dataset v1.5, you may reach me via meryemuzunper@gmail.com
