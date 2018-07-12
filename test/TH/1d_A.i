[Mesh]
  type = GeneratedMesh
  dim = 1
  xmin = 0
  xmax = 1.4
  nx = 100
[]

[Modules]
  [./FluidProperties]
    [./water_uo]
      type = SimpleFluidProperties
    [../]
  [../]
[]

[Materials]
  [./matrix_t]
    type = TigerUncoupledThermalMaterialTH
    fp_UO = water_uo
    porosity = 1.0
    conductivity_type = isotropic
    lambda = 0
    density = 0
    specific_heat = 0
    user_velocity = vel
  [../]
[]

[BCs]
  [./left_t]
    type = DirichletBC
    variable = temperature
    boundary = left
    value = 0
  [../]
[]

[Functions]
  [./vel]
    type = ParsedVectorFunction
    value_x = '1.0'
  [../]
  [./initial]
    type = ParsedFunction
    value = 'if(x<0.4, 0.5*(1+cos(5*3.14*(x-0.2))),0.0)'
  [../]
[]

[Variables]
  [./temperature]
  [../]
[]

[ICs]
  [./init_temp]
    type = FunctionIC
    variable = temperature
    function = initial
  [../]
[]

[Kernels]
  [./T_advect]
    type = TigerAdvectionKernelTH
    variable = temperature
  [../]
  [./T_time]
    type =  TigerTimeDerivativeT
    variable = temperature
  [../]
[]

[Executioner]
  type = Transient
  end_time = 1
  num_steps = 10
  solve_type = NEWTON
  #[./TimeIntegrator]
  #   type = CrankNicolson
  #[../]
  petsc_options_iname = '-ksp_type -pc_type -snes_atol -snes_rtol -snes_max_it -ksp_max_it -sub_pc_type -sub_pc_factor_shift_type'
  petsc_options_value = 'gmres asm 1E-10 1E-10 200 500 lu NONZERO'
[]

[Outputs]
  exodus = true
  print_linear_residuals = false
[]