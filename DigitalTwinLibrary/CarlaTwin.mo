within DigitalTwinLibrary;

package CarlaTwin
  import Modelica.Utilities.Files.loadResource;

  block PropDriver "Simple Proportional controller driver"
    parameter String CycleFileName = "cycleName.txt" "Drive Cycle Name ex: \"sort1.txt\"";
    parameter Real k "Controller gain";
    parameter Real yMax = 1.e6 "Max output value (absolute)";
    parameter Modelica.Blocks.Types.Extrapolation extrapolation = Modelica.Blocks.Types.Extrapolation.LastTwoPoints "Extrapolation of data outside the definition range";
    Modelica.Blocks.Interfaces.RealInput V annotation(
      Placement(visible = true, transformation(origin = {0, -66}, extent = {{-14, -14}, {14, 14}}, rotation = 90), iconTransformation(origin = {0, -112}, extent = {{-12, -12}, {12, 12}}, rotation = 90)));
    Modelica.Blocks.Math.UnitConversions.From_kmh from_kmh annotation(
      Placement(visible = true, transformation(extent = {{-68, -10}, {-48, 10}}, rotation = 0)));
    Modelica.Blocks.Sources.CombiTimeTable driveCyc(columns = {2}, extrapolation = extrapolation, fileName = "C://Program Files//OpenModelica1.16.1-64bit//lib//omlibrary//DigitalTwinLibrary//Resources//Data//Tables//data_from_carla.txt", tableName = "table1", tableOnFile = true) annotation(
      Placement(visible = true, transformation(extent = {{-98, -10}, {-78, 10}}, rotation = 0)));
    Modelica.Blocks.Math.Feedback feedback annotation(
      Placement(visible = true, transformation(extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Blocks.Math.Gain gain(k = 100) annotation(
      Placement(visible = true, transformation(extent = {{14, -10}, {34, 10}}, rotation = 0)));
    Modelica.Blocks.Nonlinear.Limiter limAcc(uMax = yMax, uMin = 0) annotation(
      Placement(visible = true, transformation(origin = {2, 40}, extent = {{52, -10}, {72, 10}}, rotation = 0)));
    Modelica.Blocks.Nonlinear.Limiter limBrak(uMax = 0, uMin = -yMax) annotation(
      Placement(visible = true, transformation(origin = {0, -40}, extent = {{52, -10}, {72, 10}}, rotation = 0)));
    Modelica.Blocks.Interfaces.RealOutput tauRef(unit = "N.m") annotation(
      Placement(visible = true, transformation(extent = {{100, -10}, {120, 10}}, rotation = 0), iconTransformation(extent = {{100, -10}, {120, 10}}, rotation = 0)));
    Modelica.Blocks.Interfaces.RealOutput accelTau annotation(
      Placement(visible = true, transformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(extent = {{-10, 10}, {10, 30}}, rotation = 0)));
    Modelica.Blocks.Interfaces.RealOutput brakeTau annotation(
      Placement(visible = true, transformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(extent = {{-10, -30}, {10, -10}}, rotation = 0)));
    Modelica.Blocks.Math.UnitConversions.To_kmh to_kmh annotation(
      Placement(visible = true, transformation(origin = {-22, 28}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  equation
    connect(V, feedback.u2) annotation(
      Line(points = {{0, -66}, {0, -66}, {0, -8}, {0, -8}}, color = {0, 0, 127}));
    connect(from_kmh.u, driveCyc.y[1]) annotation(
      Line(points = {{-70, 0}, {-77, 0}}, color = {0, 0, 127}));
    connect(feedback.y, gain.u) annotation(
      Line(points = {{9, 0}, {12, 0}}, color = {0, 0, 127}));
    connect(limBrak.y, brakeTau) annotation(
      Line(points = {{73, -40}, {104, -40}, {104, -40}, {110, -40}}, color = {0, 0, 127}));
    connect(limAcc.y, accelTau) annotation(
      Line(points = {{75, 40}, {102, 40}, {102, 40}, {110, 40}}, color = {0, 0, 127}));
    connect(limBrak.u, gain.y) annotation(
      Line(points = {{50, -40}, {40, -40}, {40, 0}, {35, 0}, {35, 0}}, color = {0, 0, 127}));
    connect(limAcc.u, gain.y) annotation(
      Line(points = {{52, 40}, {40, 40}, {40, 0}, {35, 0}, {35, 0}}, color = {0, 0, 127}));
    connect(gain.y, tauRef) annotation(
      Line(points = {{35, 0}, {110, 0}, {110, 0}}, color = {0, 0, 127}));
    connect(from_kmh.y, to_kmh.u) annotation(
      Line(points = {{-46, 0}, {-34, 0}, {-34, 28}}, color = {0, 0, 127}));
    connect(to_kmh.y, feedback.u1) annotation(
      Line(points = {{-10, 28}, {-10, 14}, {-8, 14}, {-8, 0}}, color = {0, 0, 127}));
    annotation(
      Documentation(info = "<html><head></head><body><p>Simple driver model.</p><p>It reads a reference cycle from a file then controls speed with a simple proportional feedback law.</p>
        </body></html>"),
      Icon(coordinateSystem(preserveAspectRatio = false, initialScale = 0.1), graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Ellipse(fillColor = {255, 213, 170}, fillPattern = FillPattern.Solid, extent = {{-23, 22}, {-12, -4}}, endAngle = 360), Text(origin = {2, -0.1894}, lineColor = {0, 0, 255}, extent = {{-104, 142.189}, {98, 104}}, textString = "%name"), Polygon(fillColor = {215, 215, 215}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-22, -60}, {-42, -88}, {-16, -88}, {16, -88}, {-22, -60}}), Polygon(fillColor = {135, 135, 135}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-32, 40}, {-62, -52}, {-30, -52}, {-30, -52}, {-32, 40}}, smooth = Smooth.Bezier), Polygon(fillColor = {135, 135, 135}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-68, -36}, {-14, -90}, {10, -50}, {0, -50}, {-68, -36}}, smooth = Smooth.Bezier), Polygon(fillColor = {175, 175, 175}, fillPattern = FillPattern.Solid, points = {{-22, 10}, {-30, 6}, {-40, -48}, {2, -46}, {2, -34}, {0, 2}, {-22, 10}}, smooth = Smooth.Bezier), Ellipse(fillColor = {255, 213, 170}, fillPattern = FillPattern.Solid, extent = {{-30, 44}, {-3, 10}}, endAngle = 360), Polygon(pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-38, 34}, {-16, 50}, {-2, 36}, {4, 36}, {6, 36}, {-38, 34}}, smooth = Smooth.Bezier), Polygon(fillColor = {95, 95, 95}, fillPattern = FillPattern.Solid, points = {{30, -44}, {-32, -28}, {-36, -44}, {-24, -58}, {30, -44}}, smooth = Smooth.Bezier), Polygon(fillPattern = FillPattern.Solid, points = {{42, -70}, {36, -84}, {48, -78}, {52, -72}, {50, -68}, {42, -70}}, smooth = Smooth.Bezier), Line(points = {{48, -14}, {26, 0}, {26, 0}}, thickness = 0.5), Line(points = {{20, -10}, {34, 10}, {34, 10}}, thickness = 0.5), Polygon(fillColor = {255, 213, 170}, fillPattern = FillPattern.Solid, points = {{28, 4}, {32, 8}, {28, 2}, {34, 6}, {30, 2}, {34, 4}, {30, 0}, {26, 2}, {34, 0}, {26, 0}, {26, 2}, {28, 4}, {28, 4}, {26, 2}, {26, 2}, {26, 2}, {28, 8}, {28, 6}, {28, 4}}, smooth = Smooth.Bezier), Polygon(fillColor = {175, 175, 175}, fillPattern = FillPattern.Solid, points = {{-18, 0}, {28, 6}, {26, -2}, {-16, -16}, {-20, -16}, {-24, -6}, {-18, 0}}, smooth = Smooth.Bezier), Polygon(fillColor = {215, 215, 215}, fillPattern = FillPattern.Solid, points = {{72, -6}, {48, -6}, {36, -26}, {58, -86}, {72, -86}, {72, -6}}), Polygon(fillColor = {95, 95, 95}, fillPattern = FillPattern.Solid, points = {{49, -94}, {17, -40}, {7, -44}, {-1, -50}, {49, -94}}, smooth = Smooth.Bezier), Line(points = {{-7, 31}, {-3, 29}}), Line(points = {{-9, 18}, {-5, 18}}), Line(points = {{-7, 31}, {-3, 31}}), Text(lineColor = {238, 46, 47}, extent = {{-100, 90}, {100, 58}}, textString = "%CycleFileName")}),
      Diagram(coordinateSystem(extent = {{-100, -60}, {100, 60}}, preserveAspectRatio = false, initialScale = 0.1, grid = {2, 2})));
  end PropDriver;

  model DragForceModel
    Modelica.Mechanics.Translational.Components.Mass mass(L = 4.5, a(fixed = false, start = start_acc.k), v(fixed = false, start = start_vel.k)) annotation(
      Placement(visible = true, transformation(origin = {-17, 39}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
    Modelica.Mechanics.Translational.Sensors.SpeedSensor speedSensor annotation(
      Placement(visible = true, transformation(origin = {19, 39}, extent = {{-13, -13}, {13, 13}}, rotation = 0)));
    Modelica.Blocks.Sources.Constant start_vel annotation(
      Placement(visible = true, transformation(origin = {-52, 38}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Blocks.Sources.Constant start_acc annotation(
      Placement(visible = true, transformation(origin = {-52, 8}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  DragForce dragForce(Cx = 0.23, S = 2.22, m = 1600, startBackward(fixed = false, start = false), startForward(start = true)) annotation(
      Placement(visible = true, transformation(origin = {-21, -1}, extent = {{-13, -13}, {13, 13}}, rotation = 0)));
  equation
    connect(speedSensor.flange, mass.flange_b) annotation(
      Line(points = {{6, 39}, {-2, 39}}, color = {0, 127, 0}));
    connect(dragForce.flange, mass.flange_b) annotation(
      Line(points = {{-8, -1}, {-2, -1}, {-2, 39}}, color = {0, 127, 0}));
  protected
  end DragForceModel;

  model DragForce "Vehicle rolling and aerodinamical drag force"
    import Modelica.Constants.g_n;
    extends Modelica.Mechanics.Translational.Interfaces.PartialElementaryOneFlangeAndSupport2;
    extends Modelica.Mechanics.Translational.Interfaces.PartialFriction;
    Modelica.SIunits.Force f "Total drag force";
    Modelica.SIunits.Velocity v "vehicle velocity";
    Modelica.SIunits.Acceleration a "Absolute acceleration of flange";
    Real Sign;
    parameter Modelica.SIunits.Mass m "vehicle mass";
    parameter Modelica.SIunits.Density rho = 1.226 "air density";
    parameter Modelica.SIunits.Area S "vehicle cross area";
    parameter Real fc(start = 0.01) "rolling friction coefficient";
    parameter Real Cx "aerodinamic drag coefficient";
  protected
    parameter Real A = fc * m * g_n;
    parameter Real B = 1 / 2 * rho * S * Cx;
  equation
//  s = flange.s;
    v = der(s);
    a = der(v);
// Le seguenti definizioni seguono l'ordine e le richieste del modello "PartialFriction" di
// Modelica.Mechanics.Translational.Interfaces"
    v_relfric = v;
    a_relfric = a;
    f0 = A "force at 0 speed 0 but with slip";
    f0_max = A "max force at 0 speed without slip";
    free = false "in principle should become true whenthe wheel loose contact with road";
// Now the computation of f, and its attribution to the flange:
    flange.f - f = 0;
// friction force
    if v > 0 then
      Sign = 1;
    else
      Sign = -1;
    end if;
    f - B * v ^ 2 * Sign = if locked then sa * unitForce else f0 * (if startForward then Modelica.Math.tempInterpol1(v, [0, 1], 2) else if startBackward then -Modelica.Math.tempInterpol1(-v, [0, 1], 2) else if pre(mode) == Forward then Modelica.Math.tempInterpol1(v, [0, 1], 2) else -Modelica.Math.tempInterpol1(-v, [0, 1], 2));
    annotation(
      Documentation(info = "<html>
  <p>This component models the total (rolling and aerodynamic) vehicle drag resistance: </p>
  <p>F=fc*m*g+(1/2)*rho*Cx*S*v^2 </p>
  <p>It models reliably the stuck phase. Based on Modelica-Intrerfaces.PartialFriction model </p>
  </html>"),
      Icon(coordinateSystem(preserveAspectRatio = true, extent = {{-100, -100}, {100, 100}}), graphics = {Polygon(points = {{-98, 10}, {22, 10}, {22, 41}, {92, 0}, {22, -41}, {22, -10}, {-98, -10}, {-98, 10}}, lineColor = {0, 127, 0}, fillColor = {215, 215, 215}, fillPattern = FillPattern.Solid), Line(points = {{-42, -50}, {87, -50}}, color = {0, 0, 0}), Polygon(points = {{-72, -50}, {-41, -40}, {-41, -60}, {-72, -50}}, lineColor = {0, 0, 0}, fillColor = {128, 128, 128}, fillPattern = FillPattern.Solid), Line(points = {{-90, -90}, {-70, -88}, {-50, -82}, {-30, -72}, {-10, -58}, {10, -40}, {30, -18}, {50, 8}, {70, 38}, {90, 72}, {110, 110}}, color = {0, 0, 255}, thickness = 0.5), Text(extent = {{-82, 90}, {80, 50}}, lineColor = {0, 0, 255}, textString = "%name")}),
      Diagram(coordinateSystem(preserveAspectRatio = true, extent = {{-100, -100}, {100, 100}}), graphics));
  end DragForce;

  model SimpleCarModel "Simulates a very basic Electric Vehicle"
    import Modelica;
    extends Modelica.Icons.Example;
    Modelica.Mechanics.Rotational.Sources.Torque torque annotation(
      Placement(visible = true, transformation(extent = {{-84, 10}, {-64, 30}}, rotation = 0)));
    Modelica.Mechanics.Translational.Components.Mass mass(m = 1300) annotation(
      Placement(visible = true, transformation(extent = {{26, 10}, {46, 30}}, rotation = 0)));
    Modelica.Mechanics.Translational.Sensors.SpeedSensor velSens annotation(
      Placement(visible = true, transformation(origin = {46, -8}, extent = {{-10, -10}, {10, 10}}, rotation = 270)));
    Modelica.Mechanics.Rotational.Components.IdealRollingWheel wheel(radius = 0.5715) annotation(
      Placement(visible = true, transformation(extent = {{-8, -24}, {12, -4}}, rotation = 0)));
    Modelica.Mechanics.Rotational.Components.Inertia inertia(J = 5) annotation(
      Placement(visible = true, transformation(extent = {{-56, 10}, {-36, 30}}, rotation = 0)));
    DigitalTwinLibrary.CarlaTwin.DragForce dragF(Cx = 0, S = 0, fc = 0, m = 0) annotation(
      Placement(visible = true, transformation(origin = {82, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
    DigitalTwinLibrary.CarlaTwin.PropDriver propDriver(CycleFileName = "data_from_carla.txt", k = 100) annotation(
      Placement(visible = true, transformation(origin = {-104, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Mechanics.Rotational.Components.IdealGear idealGear(ratio = 6) annotation(
      Placement(visible = true, transformation(origin = {-20, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  equation
    connect(inertia.flange_a, torque.flange) annotation(
      Line(points = {{-56, 20}, {-64, 20}}));
    connect(mass.flange_a, wheel.flangeT) annotation(
      Line(points = {{26, 20}, {22, 20}, {22, -14}, {12, -14}}, color = {0, 127, 0}));
    connect(velSens.flange, mass.flange_b) annotation(
      Line(points = {{46, 2}, {46, 20}}, color = {0, 127, 0}));
    connect(propDriver.tauRef, torque.tau) annotation(
      Line(points = {{-93, 20}, {-86, 20}}, color = {0, 0, 127}));
    connect(velSens.v, propDriver.V) annotation(
      Line(points = {{46, -19}, {46, -32}, {-104, -32}, {-104, 9}}, color = {0, 0, 127}));
    connect(dragF.flange, mass.flange_b) annotation(
      Line(points = {{72, 20}, {46, 20}}, color = {0, 127, 0}));
    connect(inertia.flange_b, idealGear.flange_a) annotation(
      Line(points = {{-36, 20}, {-30, 20}}));
    connect(idealGear.flange_b, wheel.flangeR) annotation(
      Line(points = {{-10, 20}, {0, 20}, {0, 2}, {-20, 2}, {-20, -14}, {-8, -14}}));
  protected
    annotation(
      experimentSetupOutput(derivatives = false),
      Documentation(info = "<html>
  <p>Very basic introductory EV model</p>
  </html>"),
      Commands,
      Diagram(coordinateSystem(extent = {{-120, -40}, {120, 40}}, preserveAspectRatio = false, initialScale = 0.1, grid = {2, 2})),
      Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = false, initialScale = 0.1, grid = {2, 2})),
      experiment(StartTime = 0, StopTime = 200, Tolerance = 0.0001, Interval = 0.1),
      __OpenModelica_simulationFlags(jacobian = "", s = "dassl", lv = "LOG_STATS"));
  end SimpleCarModel;
end CarlaTwin;
